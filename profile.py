# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

pc.defineParameter( "n", "Number of compute nodes, a number from 2 to 12", portal.ParameterType.INTEGER, 4 )
params = pc.bindParameters()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

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
#maxSize = 5

link = request.LAN("lan")

for i in range(5):
  if i == 0:
    node = request.XenVM("head")
  else:
    node = request.XenVM("worker-" + str(i))
  node.cores = 4
  node.ram = 4096
  node.routable_control_ip = "true"

  ##for i in range(6):
  #for i in range(0,params.n + 2):
  #  if i == 0:
  #    node = request.XenVM("head")
  #    node.routable_control_ip = "true"
  #  elif i == 1:
  #    node = request.XenVM("storage")
  #  else:
  #    node = request.XenVM("compute-" + str(i-1))
  #    node.cores = 4
  #    node.ram = 4096

  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
  
  iface = node.addInterface("if" + str(i+1))
  iface.component_id = "eth"+ str(i+1)
  iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
  link.addInterface(iface)
  
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/passwordless.sh"))
  node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/passwordless.sh"))
  
  if i == 0:
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nodeHead.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nodeHead.sh " + str(params.n)))
    #node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nfshead.sh"))
    #node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfshead.sh " + str(params.n)))
    #node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nfsstorage.sh"))
    #node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfsstorage.sh " + str(params.n)))
  else:
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nodeWorker.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nodeWorker.sh"))
  
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/install_docker.sh"))
  node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/install_docker.sh"))
  
# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)

#######

## Import the Portal object.
#import geni.portal as portal
## Import the ProtoGENI library.
#import geni.rspec.pg as pg
#import geni.rspec.igext as IG
#
## Create a portal context.
#pc = portal.Context()
#
## Create a Request object to start building the RSpec.
#request = pc.makeRequestRSpec()
#
#
#tourDescription = \
#"""
#This profile provides the template for a compute node with Docker installed on Ubuntu 18.04
#"""
#
##
## Setup the Tour info with the above description and instructions.
##  
#tour = IG.Tour()
#tour.Description(IG.Tour.TEXT,tourDescription)
#request.addTour(tour)
#
#prefixForIP = "192.168.1."
#
#link = request.LAN("lan")
#
#for i in range(5):
#  if i == 0:
#    node = request.XenVM("head")
#  else:
#    node = request.XenVM("worker-" + str(i))
#  node.cores = 4
#  node.ram = 4096
#  node.routable_control_ip = "true"
# 
#  #node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
#  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:CENTOS7-64-STD"
#  
#  #iface = node.addInterface("if" + str(i))
#  #iface.component_id = "eth1"
#  iface = node.addInterface("if" + str(i+1))
#  iface.component_id = "eth"+ str(i+1)
#  iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
#  link.addInterface(iface)
#  
#  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/passwordless.sh"))
#  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/install_docker.sh"))
#  
#  node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/passwordless.sh"))
#  node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/install_docker.sh"))
#  
#  
## Print the RSpec to the enclosing page.
#pc.printRequestRSpec(request)