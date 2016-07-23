Facter.add(:icinga2_programdata) do
  confine :kernel => :windows
  setcode do
    require 'win32/registry'

    value = nil
    begin
      hive = Win32::Registry::HKEY_LOCAL_MACHINE
      #hive.open('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', Win32::Registry::KEY_READ | 0x100) do |reg|
      #  value = reg['ProgramData']
      hive.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', Win32::Registry::KEY_READ | 0x100) do |reg|
        value = reg['Common AppData']
        value = value + "\\Icinga2"
        value = value.gsub("\\","/")
        if !File.directory? value
          value = nil
        end
      end
      rescue Win32::Registry::Error => e
        value = nil
      end
      value
    end
end
