# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

pc.defineParameter( "n", "Number of worker nodes (2 or more)", portal.ParameterType.INTEGER, 2 )
pc.defineParameter( "pfscount", "Number of parallel file system nodes (1 or more). If you change this, also change pfs/pfs_servers.json to match!", portal.ParameterType.INTEGER, 4 )
pc.defineParameter( "corecount", "Number of cores in each node (2 or more).  NB: Make certain your requested cluster can supply this quantity.", portal.ParameterType.INTEGER, 4 )
pc.defineParameter( "ramsize", "MB of RAM in each node (2048 or more).  NB: Make certain your requested cluster can supply this quantity.", portal.ParameterType.INTEGER, 4096 )
params = pc.bindParameters()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

if params.n < 2:
  portal.context.reportError( portal.ParameterError( "You must request at least 2 worker nodes." ) )
if params.pfscount < 1:
  portal.context.reportError( portal.ParameterError( "You must request at least 1 parallel file system node." ) )
if params.corecount < 2:
  portal.context.reportError( portal.ParameterError( "You must request at least 2 cores per node." ) )
if params.ramsize < 2048:
  portal.context.reportError( portal.ParameterError( "You must request at least 2048 MB of RAM per node." ) )

# List for the nodes
nodeList = []

tourDescription = \
"""
This profile provides a Slurm and Open MPI cluster installed on Ubuntu 18.04.
"""

#
# Set up the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
request.addTour(tour)

prefixForIP = "192.168.1."

slurmNum = params.n + 1

# Set up for multiple pfs machines
beegfnNum = []
for x in range((params.pfscount + 1)):
  beegfnNum.append(params.n + 2 + x)

# The number of machines is: (n of workers) plus (pfscount of pfs machines) plus (head plus nfs)
machineCount = params.n + params.pfscount + 2

link = request.LAN("lan")

for i in range(0,machineCount):
  if i == 0:
    node = request.XenVM("nfs")
  elif i in beegfnNum:
    pfsNumber = i - (params.n + 1)
    pfsName = "pfs-" + str(pfsNumber)
    node = request.XenVM(pfsName)
  elif i == slurmNum:
    node = request.XenVM("head")
  else:
    node = request.XenVM("worker-" + str(i))
  
  node.cores = params.corecount
  node.ram = params.ramsize
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
  
  iface = node.addInterface("if" + str(i+1))
  iface.component_id = "eth"+ str(i+1)
  iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
  
  if i == slurmNum:
    node.routable_control_ip = "true" 
  
  link.addInterface(iface)  
  
  # Set scripts in the repository executable and readable.
  node.addService(pg.Execute(shell="sh", command="sudo find /local/repository/ -type f -iname \"*.sh\" -exec chmod 755 {} \;"))
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/beegfs/beegfs-deb8.list")) 
  
  if i == 0:
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfs/startingNFSInstalls.sh " + str(params.n) + " " + str(slurmNum)))
    #node.addService(pg.Execute(shell="sh", command="sudo /local/repository/beegfs/clientBeeGFS.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless/addpasswordless.sh " + str(params.n)))
  elif i in beegfnNum:
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/ldap/installLdapClient.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/beegfs/serverBeeGFS.sh " + pfsName))
  elif i == slurmNum:
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/ldap/installLdapClient.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfs/installNfsClient.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/slurm/slurmHead.sh " + str(params.n) + " " + str(params.corecount) + " " + str(params.ramsize)))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/mpi/install_mpi.sh " + str(params.n)))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/beegfs/clientBeeGFS.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless/addpasswordless.sh " + str(params.n)))
  else:
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/workers/nodeWorker.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/slurm/slurmClient.sh " + str(params.n)))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/beegfs/clientBeeGFS.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless/addpasswordless.sh " + str(params.n)))
  
# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
