pkgs = data.frame(installed.packages())
data = data.frame(pkgs$Package, pkgs$Version)
print(data, row.names = FALSE)