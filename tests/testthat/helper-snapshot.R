# Render a tag for a markup snapshot.
#
# The package's whole contract is that the HTML matches the Bootstrap 5.3
# reference, so the snapshots are the contract written down: any change to a
# class, an attribute or the nesting shows up as a diff instead of passing
# unnoticed between the targeted assertions.
snap <- function(x) {
  cat(as.character(x), "\n")
}
