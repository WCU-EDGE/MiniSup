# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Lists for the nodes and such
nodeList = []

tourDescription = \
"""
This profile provides the template for a full research cluster with head node, scheduler, compute nodes, and shared file systems.
First node (head) should contain: 
- Shared home directory using Networked File System
- Management server for SLURM
Second node (metadata) should contain:
- Metadata server for SLURM
Third node (storage):
- Shared software directory (/software) using Networked File System
Remaining three nodes (computing):
- Compute nodes  

Instructions:
I will be the pattern of all patience; I will say nothing. --King Lear, Act 3, Scene 2
"""

#
# Setup the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
request.addTour(tour)

portal.context.defineParameter( "n", "Number of compute nodes, an even number from 2 to 12", portal.ParameterType.INTEGER, 4 )

prefixForIP = "192.168.1."
#maxSize = 5

link = request.LAN("lan")

#for i in range(6):
for i in range(0,params.n + 1):
  if i == 0:
    node = request.XenVM("head")
    node.routable_control_ip = "true"
  elif i == 1:
    node = request.XenVM("storage")
  else:
    node = request.XenVM("compute-" + str(i-1))
    node.cores = 4
    node.ram = 4096
    
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:CENTOS7-64-STD"
  
  iface = node.addInterface("if" + str(i+1))
  iface.component_id = "eth"+ str(i+1)
  iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
  link.addInterface(iface)
  
  
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/passwordless.sh"))
  node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless.sh"))
  
  if i == 0:
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nfshead.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfshead.sh"))
    #node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/install_mpi.sh"))
    #node.addService(pg.Execute(shell="sh", command="sudo /local/repository/install_mpi.sh"))
  elif i == 1:
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nfsstorage.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfsstorage.sh " + str(params.n)))
    #node.addService(pg.Execute(shell="sh", command="sudo su jk880380 -c 'cp /local/repository/source/* /users/jk880380/scratch'"))
  else:
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nfsclient.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfsclient.sh"))
  
  # This code segment is added per Benjamin Walker's solution to address the StrictHostKeyCheck issue of ssh
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/ssh_setup.sh"))
  #node.addService(pg.Execute(shell="sh", command="sudo -H -u lngo bash -c '/local/repository/ssh_setup.sh'"))
  node.addService(pg.Execute(shell="sh", command="sudo -H -u jk880380 bash -c '/local/repository/ssh_setup.sh'"))
 
  #node.addService(pg.Execute(shell="sh", command="sudo su lngo -c 'cp /local/repository/source/* /users/lngo'"))
  #node.addService(pg.Execute(shell="sh", command="sudo su jk880380 -c 'cp /local/repository/source/* /users/jk880380'"))
  
# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
