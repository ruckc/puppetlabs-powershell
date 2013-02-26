require 'puppet/provider/exec'

Puppet::Type.type(:exec).provide :powershell32, :parent => Puppet::Provider::Exec do
  confine :operatingsystem => :windows

  commands :powershell => "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"

  desc <<-EOT
    Executes Powershell commands. One of the `onlyif`, `unless`, or `creates`
    parameters should be specified to ensure the command is idempotent.

    Example:
        # Rename the Guest account
        exec { 'rename-guest':
          command   => '$(Get-WMIObject Win32_UserAccount -Filter "Name=\'guest\'").Rename("new-guest")',
          unless    => 'if (Get-WmiObject Win32_UserAccount -Filter "Name=\'guest\'") { exit 1 }'
          provider  => powershell
        }
  EOT

  def run(command, check = false)
    super("\"#{POWERSHELL}\" #{command}", check)
  end

  def checkexe(command)
  end

  def validatecmd(command)
    true
  end
end
