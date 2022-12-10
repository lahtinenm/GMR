PackageInitialization = PackageInitialization or {}

function PackageInitialization.initializePackage(packageName)
  local package = _G[packageName] or {}
  _G[packageName] = package
  setmetatable(package, { __index = _G })
  setfenv(2, package)
end
