sink('C:\\Users\\User\\Desktop\\Connectivity\\Connectivity\\Scenarios\\Scenario BLM3\\output\\output_Rlog.txt')

library(rgl)
library(vegan)
library(labdsv)

solutions<-read.table('C:\\Users\\User\\Desktop\\Connectivity\\Connectivity\\Scenarios\\Scenario BLM3\\output\\output_solutionsmatrix.csv',header=TRUE, row.name=1, sep=',')
soldist<-vegdist(solutions,distance='bray')
sol.mds<-nmds(soldist,2)

bmp(file='C:\\Users\\User\\Desktop\\Connectivity\\Connectivity\\Scenarios\\Scenario BLM3\\output\\output_2d_plot.bmp',width=1346,height=748,pointsize=10)

plot(sol.mds$points, type='n', xlab='', ylab='', main='NMDS of solutions')
text(sol.mds$points, labels=row.names(solutions))

dev.off()

h<-hclust(soldist, method='complete')

bmp(file='C:\\Users\\User\\Desktop\\Connectivity\\Connectivity\\Scenarios\\Scenario BLM3\\output\\output_dendogram.bmp',width=1346,height=748,pointsize=10)

plot(h, xlab='Solutions', ylab='Disimilarity', main='Bray-Curtis dissimilarity of solutions')

dev.off()

usercut<-cutree(h,k=3)

write('solution,cluster',file='C:\\Users\\User\\Desktop\\Connectivity\\Connectivity\\Scenarios\\Scenario BLM3\\output\\output_cluster.csv')

for(i in 1:100)
{
   cat(i,file='C:\\Users\\User\\Desktop\\Connectivity\\Connectivity\\Scenarios\\Scenario BLM3\\output\\output_cluster.csv',append=TRUE)
   cat(',',file='C:\\Users\\User\\Desktop\\Connectivity\\Connectivity\\Scenarios\\Scenario BLM3\\output\\output_cluster.csv',append=TRUE)
   write(usercut[i],file='C:\\Users\\User\\Desktop\\Connectivity\\Connectivity\\Scenarios\\Scenario BLM3\\output\\output_cluster.csv',append=TRUE)
}

sol3d.mds<-nmds(soldist,3)

plot3d(sol3d.mds$points, xlab = 'x', ylab = 'y', zlab = 'z', type='n', theta=40, phi=30, ticktype='detailed', main='NMDS of solutions')
text3d(sol3d.mds$points,texts=row.names(solutions),pretty='TRUE')
play3d(spin3d(axis=c(1,0,0), rpm=3), duration=10)
play3d(spin3d(axis=c(0,1,0), rpm=3), duration=10)
play3d(spin3d(axis=c(0,0,1), rpm=3), duration=10)

