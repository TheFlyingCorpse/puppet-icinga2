Facter.add(:icinga2_installdir) do
  confine :operatingsystem => :windows
  setcode do
    installdir = nil
    InstallLocation = Facter::Util::Resolution.exec('wmic product where "Name like \'Icinga 2\'" get InstallLocation')
    installdir = InstallLocation.gsub("\\","/")
    installdir = installdir.gsub(/(\/)+$/,'')
    installdir = installdir.gsub("InstallLocation","")
  end
end
