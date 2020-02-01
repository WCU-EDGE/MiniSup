#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc,char *argv[]){
  int size, rank; 
  int *sray,*rray;
  int *sdisp,*scounts,*rdisp,*rcounts;
  int ssize,rsize,i,k,j;
  float z;

  MPI_Init(&argc,&argv);
  MPI_Comm_size( MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    
  scounts=(int*)malloc(sizeof(int)*size);
  rcounts=(int*)malloc(sizeof(int)*size);
  sdisp=(int*)malloc(sizeof(int)*size);
  rdisp=(int*)malloc(sizeof(int)*size);

  
  /* find out how much data to send */
  srand((unsigned int) rank);    
  for(i=0;i<size;i++){
    z = (float) rand()/RAND_MAX;
    scounts[i]=(int)(5.0 * z) + 1;
  }
    
  printf("rank= %d scounts= %d %d %d %d\n",rank,scounts[0],scounts[1],scounts[2],scounts[3]);

  for(i=0;i<size;i++)
    printf("%d ",scounts[i]);
  printf("\n");
    
  /* tell the other processors how much data is coming */
  MPI_Alltoall(scounts,1,MPI_INT,rcounts,1,MPI_INT,MPI_COMM_WORLD);

  /* calculate displacements and the size of the arrays */
  sdisp[0]=0;
  for(i=1;i<size;i++){
    sdisp[i]=scounts[i-1]+sdisp[i-1];
  }
  rdisp[0]=0;
  for(i=1;i<size;i++){
    rdisp[i]=rcounts[i-1]+rdisp[i-1];
  }
  ssize=0;
  rsize=0;
  for(i=0;i<size;i++){
    ssize=ssize+scounts[i];
    rsize=rsize+rcounts[i];
  }
  
  /* allocate send and rec arrays */
  sray=(int*)malloc(sizeof(int)*ssize);
  rray=(int*)malloc(sizeof(int)*rsize);
  for(i=0;i<ssize;i++)
    sray[i]=rank;

  /* send/rec different amounts of data to/from each processor */
  MPI_Alltoallv( sray,scounts,sdisp,MPI_INT,rray,rcounts,rdisp,MPI_INT,MPI_COMM_WORLD);
                  
  printf("rank= %d rray=",rank);
  for(i=0;i<rsize;i++)
    printf("%d ",rray[i]);
  printf("\n");
  MPI_Finalize();
}