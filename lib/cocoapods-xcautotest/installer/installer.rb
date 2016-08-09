require 'fileutils'

module CocoaPodsXCAutoTest
  class Installer
    class << self

      # Register for the pre-install hooks to setup & run Keys
      Pod::HooksManager.register('cocoapods-xcautotest', :pre_install) do |context, options|
        Installer.setup(context.podfile, options)
      end

      def setup(podfile, options)
        auto_target_names = options['target'] || options['targets']
        auto_target_names = ([] << auto_target_names).flatten

        raise "Need to add 'targets', or 'target' to the plugin options" unless auto_target_names

        installation_root = Pod::Config.instance.installation_root
        pod_path = installation_root.+('Pods/XCAutoTest/')

        # move our Pod metadata in to the Pods dir        
        FileUtils.cp_r  Pathname(__dir__) + "../pod", pod_path

        auto_target_names.each do |auto_target_name|
          pod_target = podfile.target_definition_list.find do |target|
            target.label == "Pods-#{auto_target_name}"
          end

          pod_target.store_pod('XCAutoTest', path: pod_path.to_path) if pod_target
        end
      end
    end
  end
end