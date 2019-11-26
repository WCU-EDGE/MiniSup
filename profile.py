# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

pc.defineParameter( "n", "Number of worker nodes, a number from 2 to 5", portal.ParameterType.INTEGER, 2 )
params = pc.bindParameters()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

if params.n < 2 or params.n > 5:
  portal.context.reportError( portal.ParameterError( "You must choose at least 2 and no more than 5 worker nodes." ) )

# Lists for the nodes and such
nodeList = []

tourDescription = \
"""
This profile provides the template for a compute node with Docker installed on Ubuntu 18.04
"""

#
# Setup the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
request.addTour(tour)

prefixForIP = "192.168.1."

beegfnNum = params.n + 1
slurmNum = params.n + 2
#loginNum = params.n + 3

link = request.LAN("lan")

###for i in range(0,params.n + 1):
###for i in range(0,params.n + 2):
###for i in range(0,params.n + 4):
for i in range(0,params.n + 3):
  if i == 0:
    #node = request.XenVM("head")
    node = request.XenVM("nfs")
    #node.routable_control_ip = "true"
  elif i == beegfnNum:
    #node = request.XenVM("beenode")
    node = request.XenVM("pfs")
  elif i == slurmNum:
    #node = request.XenVM("loginnode")
    node = request.XenVM("head")
    #node.routable_control_ip = "true"  
  else:
    node = request.XenVM("worker-" + str(i))
  node.cores = 4
  node.ram = 4096
  
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
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nodeHead.sh " + str(params.n) + " " + str(slurmNum)))
    #node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nodeHead.sh " + str(params.n) + " " + str(slurmNum) + " " + str(loginNum)))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/docker/install_docker.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/beegfs/clientBeeGFS.sh"))
    #node.addService(pg.Execute(shell="sh", command="sudo /local/repository/mpi/install_mpi.sh " + str(params.n)))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless/addpasswordless.sh " + str(params.n)))
  elif i == beegfnNum:
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/beegfs/serverBeeGFS.sh " + str(params.n)))
  elif i == slurmNum:
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/ldap/installLdapClient.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfs/installNfsClient.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/beegfs/clientBeeGFS.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/slurm/slurmHead.sh " + str(params.n)))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/mpi/install_mpi.sh " + str(params.n)))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless/addpasswordless.sh " + str(params.n)))
  else:
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/docker/install_docker.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nodeWorker.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/beegfs/clientBeeGFS.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/slurm/slurmClient.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless/addpasswordless.sh " + str(params.n)))
  
# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)


