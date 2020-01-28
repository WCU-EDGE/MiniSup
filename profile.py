# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

pc.defineParameter( "n", "This is not the active branch of the MiniSup project!", portal.ParameterType.INTEGER, 2 )
params = pc.bindParameters()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

if params.n < 10000:
  portal.context.reportError( portal.ParameterError( "This is not the active branch of the MiniSup project!" ) )

# Lists for the nodes and such
nodeList = []

tourDescription = \
"""
This profile provides a Slurm and Open MPI cluster installed on Ubuntu 18.04.
"""
  
# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
