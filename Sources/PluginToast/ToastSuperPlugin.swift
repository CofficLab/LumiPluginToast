import Combine
import Foundation
import KernelCore
import LumiLoggingKit
import os
import ProviderDocsView
import ProviderRootView
import ProviderToast

// MARK: - Toast SuperPlugin

/// Shared Toast plugin for Lumi-family applications.
///
/// The plugin registers a concrete `ToastProviding` implementation and, when
/// the host exposes `RootViewProviding`, mounts the standard toast and error
/// overlays at the outermost root-view boundary.
@MainActor
public final class ToastSuperPlugin: SuperPlugin, SuperLog {
    nonisolated static let logger = Logger(
        subsystem: "com.coffic.lumi.plugin.toast",
        category: "Toast"
    )

    public let id = "com.coffic.lumi.plugin.toast"
    public let order = 10
    public let metadata = PluginMetadata(
        id: "com.coffic.lumi.plugin.toast",
        name: "Toast",
        description: "Shared toast and persistent error notifications",
        category: .core,
        stage: .stable,
        policy: .required
    )

    /// The observable state machine rendered by `ToastOverlay`.
    public let center = ToastCenter()

    /// Stable root-overlay identifier used for mounting and removal.
    static let overlayID = "lumi-plugin-toast"

    public init() {}

    public func onRegister(kernel: KernelCoreContainer) throws {
        kernel.resolveProvider((any DocsViewProviding).self)?.addAbout(
            DocsEntry(id: id, name: metadata.name) { ToastAboutView() }
        )
    }

    public func onUnregister(kernel: KernelCoreContainer) throws {
        kernel.resolveProvider((any DocsViewProviding).self)?.removeEntries(id: id)
    }

    public func onBoot(kernel: KernelCoreContainer) throws {
        // Replace the host's no-op fallback before other plugins resolve the
        // provider during their own boot phase.
        kernel.unregisterProvider((any ToastProviding).self)
        try kernel.registerProvider((any ToastProviding).self, center)

        guard let rootView = kernel.resolveProvider((any RootViewProviding).self) else {
            Self.logger.error("\(self.t)RootViewProviding not registered; skip overlay mount")
            return
        }

        let center = self.center
        rootView.addOverlays([
            RootOverlayItem(id: Self.overlayID, order: 10_000) { content in
                ToastOverlay(content: content, center: center)
            },
        ])
    }

    public func onShutdown(kernel: KernelCoreContainer) throws {
        center.dismiss()
        kernel.resolveProvider((any RootViewProviding).self)?
            .removeOverlays(ids: [Self.overlayID])
    }
}
