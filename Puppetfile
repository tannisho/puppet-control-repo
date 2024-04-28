# ==============================================================================
# SIMP Puppet modules
# ------------------------------------------------------------------------------
# The line below enables this Puppetfile to deploy all of SIMP's modules from a
# neighboring `Puppetfile.simp` file.
#
# If you install SIMP modules locally from RPMs, you can generate a current
# `Puppetfile.simp` at any time by running the command:
#
#     simp puppetfile generate > Puppetfile.simp
#
# You can regenerate a clean copy of this Puppetfile at any time by running:
#
#     simp puppetfile generate --skeleton > Puppetfile
# OR
#     simp puppetfile generate --skeleton --local-modules ENV > Puppetfile
#
# ------------------------------------------------------------------------------

instance_eval(File.read(File.join(__dir__,"Puppetfile.simp")))


# ==============================================================================
# Your site's Puppet modules
# ------------------------------------------------------------------------------
# Add your own Puppet modules here

mod 'accounts',
  :git => 'git@gl.test.local:forge/puppetlabs-accounts.git',
  :tag => 'v7.1.1'

mod 'puppet-epel',
  :git => 'git@gl.test.local:forge/puppet-epel.git',
  :tag => 'v4.1.0'

mod 'puppet-puppetboard',
  :git => 'git@gl.test.local:forge/puppet-puppetboard.git',
  :tag => 'v9.0.0'

mod 'puppet-python',
  :git => 'git@gl.test.local:forge/puppet-python.git',
  :tag => 'v6.3.0'

# ==============================================================================
# A note about Roles and Profiles
# ------------------------------------------------------------------------------
# Site administrators are strongly encouraged to use Roles and Profiles to
# keep their infrastructure management organized.
#
# It is recommended to add Roles and Profiles under a `site/` modules directory
# at the top level of the environment directory (or control repository).
#
# Further reading:
#
#   * https://github.com/puppetlabs/best-practices/blob/master/control-repo-contents.md
#   * https://puppet.com/docs/pe/latest/the_roles_and_profiles_method.html
#   * https://github.com/puppetlabs/best-practices/blob/master/puppet-code-abstraction-roles.md
#   * https://github.com/puppetlabs/best-practices/blob/master/puppet-code-abstraction-profiles.md
#
# If you prefer instead to manage your site using a separate site module, uncomment the
# following `mod` entry and replace the URL with your site module's repository:
#
# mod 'simp-site',
#  :git => 'https://github.com/simp/pupmod-simp-site'


