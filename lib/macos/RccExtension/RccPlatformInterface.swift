import Foundation
import NetworkExtension
import Librcc
import Network

class RccPlatformInterface: NSObject, LibrccPlatformInterfaceProtocol {
    private weak var provider: PacketTunnelProvider?
    private var networkSettings: NEPacketTunnelNetworkSettings?
    private var nwMonitor: NWPathMonitor?
    private var reasserting = false

    init(provider: PacketTunnelProvider) {
        self.provider = provider
    }

    func openTun(_ options: LibrccTunOptionsProtocol?, ret0_: UnsafeMutablePointer<Int32>?) throws {
        guard let options = options, let provider = provider else {
            throw NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])
        }

        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
        settings.mtu = NSNumber(value: options.getMTU())

        if options.getAutoRoute() {

            let dnsServer = try options.getDNSServerAddress()
            let dnsSettings = NEDNSSettings(servers: [dnsServer.value])
            dnsSettings.matchDomains = [""]
            dnsSettings.matchDomainsNoSearch = true
            settings.dnsSettings = dnsSettings


            var ipv4Addresses: [String] = []
            var ipv4Masks: [String] = []
            let ipv4Iterator = options.getInet4Address()!
            while ipv4Iterator.hasNext() {
                let prefix = ipv4Iterator.next()!
                ipv4Addresses.append(prefix.address())
                ipv4Masks.append(prefix.mask())
            }

            let ipv4Settings = NEIPv4Settings(addresses: ipv4Addresses, subnetMasks: ipv4Masks)
            var ipv4Routes: [NEIPv4Route] = []

            let ipv4RouteIterator = options.getInet4RouteAddress()!
            if ipv4RouteIterator.hasNext() {
                while ipv4RouteIterator.hasNext() {
                    let route = ipv4RouteIterator.next()!
                    ipv4Routes.append(NEIPv4Route(destinationAddress: route.address(), subnetMask: route.mask()))
                }
            } else if !ipv4Addresses.isEmpty {
                ipv4Routes.append(NEIPv4Route.default())
            }

            ipv4Settings.includedRoutes = ipv4Routes


            var excludedRoutes: [NEIPv4Route] = []
            excludedRoutes.append(NEIPv4Route(destinationAddress: "17.0.0.0", subnetMask: "255.0.0.0"))
            excludedRoutes.append(NEIPv4Route(destinationAddress: "224.0.0.0", subnetMask: "240.0.0.0"))
            ipv4Settings.excludedRoutes = excludedRoutes

            settings.ipv4Settings = ipv4Settings


            var ipv6Addresses: [String] = []
            var ipv6Prefixes: [NSNumber] = []
            let ipv6Iterator = options.getInet6Address()!
            while ipv6Iterator.hasNext() {
                let prefix = ipv6Iterator.next()!
                ipv6Addresses.append(prefix.address())
                ipv6Prefixes.append(NSNumber(value: prefix.prefix()))
            }

            if !ipv6Addresses.isEmpty {
                let ipv6Settings = NEIPv6Settings(addresses: ipv6Addresses, networkPrefixLengths: ipv6Prefixes)
                var ipv6Routes: [NEIPv6Route] = []

                let ipv6RouteIterator = options.getInet6RouteAddress()!
                if ipv6RouteIterator.hasNext() {
                    while ipv6RouteIterator.hasNext() {
                        let route = ipv6RouteIterator.next()!
                        ipv6Routes.append(NEIPv6Route(destinationAddress: route.address(), networkPrefixLength: NSNumber(value: route.prefix())))
                    }
                } else {
                    ipv6Routes.append(NEIPv6Route.default())
                }

                ipv6Settings.includedRoutes = ipv6Routes


                var excludedRoutesV6: [NEIPv6Route] = []
                excludedRoutesV6.append(NEIPv6Route(destinationAddress: "ff00::", networkPrefixLength: 8))
                ipv6Settings.excludedRoutes = excludedRoutesV6

                settings.ipv6Settings = ipv6Settings
            }
        }


        if options.isHTTPProxyEnabled() {
            let proxySettings = NEProxySettings()
            let proxyServer = NEProxyServer(address: options.getHTTPProxyServer(), port: Int(options.getHTTPProxyServerPort()))
            proxySettings.httpServer = proxyServer
            proxySettings.httpsServer = proxyServer
            proxySettings.httpEnabled = true
            proxySettings.httpsEnabled = true
            settings.proxySettings = proxySettings
        }

        networkSettings = settings


        let semaphore = DispatchSemaphore(value: 0)
        var settingsError: Error?

        provider.setTunnelNetworkSettings(settings) { error in
            settingsError = error
            semaphore.signal()
        }

        semaphore.wait()

        if let error = settingsError {
            throw error
        }


        guard let ret0_ = ret0_ else {
            throw NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "nil return pointer"])
        }


        if let tunFd = provider.packetFlow.value(forKeyPath: "socket.fileDescriptor") as? Int32 {
            ret0_.pointee = tunFd
            return
        }


        let tunFd = LibrccGetTunnelFileDescriptor()
        if tunFd != -1 {
            ret0_.pointee = tunFd
        } else {
            throw NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get tunnel file descriptor"])
        }
    }

    func localDNSTransport() -> LibrccLocalDNSTransportProtocol? {
        return nil
    }

    func usePlatformAutoDetectControl() -> Bool {
        return false
    }

    func autoDetectControl(_ fd: Int32) throws {

    }

    func useProcFS() -> Bool {
        return false
    }


    func findConnectionOwner(_ ipProtocol: Int32, sourceAddress: String?, sourcePort: Int32, destinationAddress: String?, destinationPort: Int32, ret0_: UnsafeMutablePointer<Int32>?) throws {
        throw NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not available on iOS"])
    }

    func packageName(byUid uid: Int32, error: NSErrorPointer) -> String {
        return ""
    }

    func uid(byPackageName packageName: String?, ret0_: UnsafeMutablePointer<Int32>?) throws {
        throw NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not available on iOS"])
    }

    func writeLog(_ message: String?) {
        guard let message = message else { return }
        provider?.writeLog(message)
    }

    func startDefaultInterfaceMonitor(_ listener: LibrccInterfaceUpdateListenerProtocol?) throws {
        guard let listener = listener else { return }

        let monitor = NWPathMonitor()
        nwMonitor = monitor

        let semaphore = DispatchSemaphore(value: 0)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.onUpdateDefaultInterface(listener, path)
            semaphore.signal()

            monitor.pathUpdateHandler = { [weak self] path in
                self?.onUpdateDefaultInterface(listener, path)
            }
        }

        monitor.start(queue: DispatchQueue.global())
        semaphore.wait()
    }

    private func onUpdateDefaultInterface(_ listener: LibrccInterfaceUpdateListenerProtocol, _ path: Network.NWPath) {
        if path.status == .unsatisfied {
            listener.updateDefaultInterface("", interfaceIndex: -1, isExpensive: false, isConstrained: false)
        } else if let defaultInterface = path.availableInterfaces.first {
            listener.updateDefaultInterface(
                defaultInterface.name,
                interfaceIndex: Int32(defaultInterface.index),
                isExpensive: path.isExpensive,
                isConstrained: path.isConstrained
            )
        }
    }

    func closeDefaultInterfaceMonitor(_ listener: LibrccInterfaceUpdateListenerProtocol?) throws {
        nwMonitor?.cancel()
        nwMonitor = nil
    }

    func getInterfaces() throws -> LibrccNetworkInterfaceIteratorProtocol {
        guard let nwMonitor = nwMonitor else {
            throw NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "NWMonitor not started"])
        }

        let path = nwMonitor.currentPath
        if path.status == .unsatisfied {
            return NetworkInterfaceArray([])
        }

        var interfaces: [LibrccNetworkInterface] = []
        for interface in path.availableInterfaces {
            let netInterface = LibrccNetworkInterface()
            netInterface.name = interface.name
            netInterface.index = Int32(interface.index)

            switch interface.type {
            case .wifi:
                netInterface.type = LibrccInterfaceTypeWIFI
            case .cellular:
                netInterface.type = LibrccInterfaceTypeCellular
            case .wiredEthernet:
                netInterface.type = LibrccInterfaceTypeEthernet
            default:
                netInterface.type = LibrccInterfaceTypeOther
            }

            interfaces.append(netInterface)
        }

        return NetworkInterfaceArray(interfaces)
    }

    func underNetworkExtension() -> Bool {
        return true
    }

    func includeAllNetworks() -> Bool {
        return false
    }

    func readWIFIState() -> LibrccWIFIState? {
        return nil
    }

    func systemCertificates() -> LibrccStringIteratorProtocol? {
        return nil
    }

    func clearDNSCache() {


    }

    func send(_ notification: LibrccNotification?) throws {

    }
}


class NetworkInterfaceArray: NSObject, LibrccNetworkInterfaceIteratorProtocol {
    private let interfaces: [LibrccNetworkInterface]
    private var index = 0

    init(_ interfaces: [LibrccNetworkInterface]) {
        self.interfaces = interfaces
    }

    func hasNext() -> Bool {
        return index < interfaces.count
    }

    func next() -> LibrccNetworkInterface? {
        defer { index += 1 }
        return interfaces[index]
    }
}
