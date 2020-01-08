# How to build OHPC 2.0 in local machine

## Get source code

```
[root@ohpc20 ohpc]# misc/get_source.sh *.spec

```

## Create local repository

* CentOS 8.1

```
[root@ohpc20-centos8 ~]# dnf -y install gcc rpm-build rpm-devel rpmlint make python3 bash coreutils diffutils patch rpmdevtools tree createrepo dnf-plugins-core

[root@ohpc20-centos8 ~]# rpmdev-setuptree

[root@ohpc20-centos8 ~]# createrepo ~/rpmbuild/RPMS

[root@ohpc20-centos8 ~]# cat > /etc/yum.repos.d/ohpc-local.repo << EOF
[ohpc-local]
name=OHPC Local
# baseurl=file:///root/rpmbuild/RPMS
# ~# python3 -m http.server
baseurl=http://127.0.0.1:8000/rpmbuild/RPMS
enabled=1
gpgcheck=0
EOF

```

* OpenSUSE Leap 15.1

```
ohpc20-leap151:~ # zypper install -y gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools tree createrepo

ohpc20-leap151:~ # rpmdev-setuptree

ohpc20-leap151:~ # createrepo ~/rpmbuild/RPMS

ohpc20-leap151:~ # cat > /etc/zypp/repos.d/ohpc-local.repo << EOF
[ohpc-local]
name=OHPC Local
enabled=1
autorefresh=1
# baseurl=file:///root/rpmbuild/RPMS
# ~# python3 -m http.server
baseurl=http://127.0.0.1:8000/rpmbuild/RPMS
type=rpm-md
gpgcheck=0
EOF

```

## Build packages

```
[root@ohpc20 ohpc]# misc/build_order.sh
lmod.spec ohpc-filesystem.spec nagios.spec docs.spec lustre.spec warewulf-common.spec warewulf-vnfs.spec warewulf-provision.spec warewulf-ipmi.spec papi.spec paraver.spec singularity.spec charliecloud.spec gnu-compilers.spec intel-compilers-devel.spec munge.spec pbspro.spec pmix.spec slurm.spec annobin.spec hwloc.spec autoconf.spec cmake.spec python.spec spack.spec valgrind.spec python34-build-patch.spec automake.spec easybuild.spec superlu.spec metis.spec gsl.spec scotch.spec openblas.spec sigar.spec python-rpm-macros.spec ipmiutil.spec python-Cython.spec ganglia.spec losf.spec prun.spec examples.spec nagios-plugins.spec mrsh.spec nhc.spec clustershell.spec genders.spec conman.spec ndoutils.spec lmod-defaults.spec release.spec tests.spec sensys.spec shine.spec warewulf-cluster.spec likwid.spec pdtoolkit.spec intel-mpi.spec mpich.spec openmpi.spec mvapich2.spec ocr.spec llvm-compilers.spec python-numpy.spec python-mpi4py.spec libtool.spec plasma.spec R.spec hdf5.spec sionlib.spec netcdf.spec netcdf-fortran.spec adios.spec pnetcdf.spec powerman.spec nrpe.spec pdsh.spec hypre.spec boost.spec opencoarrays.spec trilinos.spec fftw.spec ptscotch.spec scalapack.spec tau.spec dimemas.spec extrae.spec geopm.spec omb.spec scorep.spec imb.spec mpiP.spec python-scipy.spec netcdf-cxx4.spec mumps.spec petsc.spec superlu_dist.spec scalasca.spec slepc.spec mfem.spec
```

```
[root@ohpc20 ohpc]# for i in $(misc/build_order.sh)
do
   misc/build_rpm.sh $i;
   if [[ $? != 0 ]]; then break; fi;
done  

[root@ohpc20 ohpc]# misc/build_rpm.sh meta-packages.spec
```

```
[root@ohpc20 ohpc]# RPM_BUILD_ROOT=/home/naohirot/rpmbuild/BUILDROOT /usr/lib/rpm/check-rpaths
```
