```
naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ misc/get_source.sh *.spec

naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ curl -Lo ./components/runtimes/ocr/SOURCES/OCRv1.0.1_ohpc.tbz2 https://build.openhpc.community/source/OpenHPC:1.3:Factory/ocr-gnu/_service:download_files:OCRv1.0.1_ohpc.tbz2?rev=ee0992138d1f5ed3c0cb7a99b107ef92
```

```
naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ sudo yum -y install gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools tree createrepo yum-utils

naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ rpmdev-setuptree

naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ createrepo ~/rpmbuild/RPMS/x86_64

naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ createrepo ~/rpmbuild/RPMS/noarch

naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ sudo vi /etc/yum.repos.d/ohpc-local.repo
[ohpc-local-x86_64]
name=OHPC Local for x86_64
baseurl=file:///home/naohirot/rpmbuild/RPMS/x86_64
enabled=1
gpgcheck=0

[ohpc-local-noarch]
name=OHPC Local for noarch
baseurl=file:///home/naohirot/rpmbuild/RPMS/noarch
enabled=1
gpgcheck=0

```

```
naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ misc/build_order.sh
lua-filesystem.spec lua-bitop.spec luaposix.spec lmod.spec ohpc-filesystem.spec examples.spec losf.spec nhc.spec genders.spec clustershell.spec release.spec ganglia.spec sigar.spec python-Cython.spec python-rpm-macros.spec ipmiutil.spec intel-compilers-devel.spec gnu-compilers.spec warewulf-common.spec warewulf-vnfs.spec munge.spec pbspro.spec spack.spec python.spec cmake.spec easybuild.spec python34-build-patch.spec valgrind.spec hwloc.spec autoconf.spec lustre.spec shine.spec likwid.spec papi.spec pdtoolkit.spec ocr.spec charliecloud.spec singularity.spec openblas.spec superlu.spec metis.spec R.spec gsl.spec scotch.spec ndoutils.spec prun.spec conman.spec nagios.spec docs.spec sensys.spec lmod-defaults.spec mrsh.spec powerman.spec llvm-compilers.spec warewulf-ipmi.spec warewulf-provision.spec warewulf-cluster.spec python-numpy.spec automake.spec libtool.spec paraver.spec plasma.spec mvapich2.spec openmpi.spec intel-mpi.spec mpich.spec nagios-plugins.spec nrpe.spec tests.spec pmix.spec slurm.spec python-mpi4py.spec scalapack.spec fftw.spec boost.spec mumps.spec opencoarrays.spec hypre.spec ptscotch.spec sionlib.spec hdf5.spec pnetcdf.spec tau.spec scorep.spec imb.spec mpiP.spec geopm.spec scalasca.spec dimemas.spec extrae.spec msr-safe.spec omb.spec pdsh.spec python-scipy.spec petsc.spec superlu_dist.spec slepc.spec netcdf.spec netcdf-fortran.spec adios.spec netcdf-cxx4.spec trilinos.spec mfem.spec
```

```
naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ for i in $(misc/build_order.sh)
do
   misc/build_rpm.sh $i;
   if [[ $? != 0 ]]; then break; fi;
done  

naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ misc/build_rpm.sh meta-packages.spec
```

```
naohirot@centos7:~/work/github/ohpc[local-build-1.3.9]$ RPM_BUILD_ROOT=/home/naohirot/rpmbuild/BUILDROOT /usr/lib/rpm/check-rpaths
```

* note
  - cmake.spec
    $ sudo yum -y install bzip2-devel
  - hwloc.spec
    $ QA_RPATHS=$[ 0x0002 ] rpmbuild -ba hwloc.spec
  - gnu-compilers.spec
    $ QA_RPATHS=$[ 0x0020 ] rpmbuild -ba gnu-compilers.spec
  - llvm-compilers.spec
    NG: The keyword signature for target_link_libraries has already been used
        * cmake/modules/LLVM-Config.cmake:105 (target_link_libraries)
        * cmake/modules/AddLLVM.cmake:771 (target_link_libraries)
        It seems llvm6-compilers is not supported, but llvm4 and llvm5
    OK: llvm5-compilers-ohpc-5.0.1-29.1.src.rpm
  - munge.spec
    $ QA_RPATHS=$[ 0x0001] rpmbuild -ba munge.spec
  - superlu.spec
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/gnu8-compilers-ohpc-8.3.0-3.ohpc.1.3.6.x86_64.rpm
  - plasma.spec
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/openblas-gnu8-ohpc-0.3.7-1.ohpc.1.3.6.x86_64.rpm
  - ocr.spec
    OCRv1.0.1_ohpc.tbz2: No such file or directory
    copied from ocr-gnu8-ohpc-1.0.1-4.3.ohpc.1.3.6.src.rpm
  - python-rpm-macros.spec
    You should BuildRequire this package unless you are sure that you
    are only building for distros newer than Leap 42.2
  - python-Cython.spec
    NG: building after ipmiutil.spec
        /home/naohirot/rpmbuild/BUILD/Cython-0.26.1/Cython/Plex/Scanners.c:4:20: fatal error: Python.h: No such file or directory
    NG: building after python-mpi4py.spec
        but python34-Cython-ohpc-0.26.1-0.x86_64.rpm has been built due to the following spec definitions:
         13 %if 0%{?sles_version} || 0%{?suse_version}
         14 %define python3_prefix python3
         15 %else
         16 %define python3_prefix python34
         17 %endif
    python-scipy.spec requires python3-Cython-ohpc-0.26.1-0.x86_64.rpm
    OBS does not have python3-Cython-ohpc-0.26.1-0.src.rpm, but python-Cython-ohpc-0.23.4-20.2.src.rpm and python34-Cython-ohpc-0.26.1-31.1.src.rpm
  - lustre.spec
    lustre-2.12.3.tar.gz: No such file or directory
    copied from lustre-client-ohpc-2.12.3-12.1.ohpc.1.3.9.src.rpm
    NG: which: no mpicc in (/home/naohirot/bin:/home/naohirot/work/python/gcp/google-cloud-sdk/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/pbs/bin:/opt/pbs/bin)
    $ sudo ln -s /opt/ohpc/pub/mpi/openmpi3-gnu8/3.1.4/bin/mpicc /usr/local/bin/mpicc
    NG: configure: error: Kernel source  could not be found.
  - sensys.spec
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/sigar-devel-ohpc-1.6.5-0.11.git58097d9.ohpc.1.3.6.x86_64.rpm
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/sigar-ohpc-1.6.5-0.11.git58097d9.ohpc.1.3.6.x86_64.rpm
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/sigar-devel-ohpc-1.6.5-0.11.git58097d9.ohpc.1.3.6.x86_64.rpm
    NG: common_verbs_fake.c:64:5: error: unknown field 'ops' specified in initializer
  - tests.spec
    tests-ohpc.tar: No such file or directory
    copied from test-suite-ohpc-1.3.9-17.1.ohpc.1.3.9.src.rpm
  - slurm.spec
    "$ QA_RPATHS=$[ 0x0002] rpmbuild -ba slurm.spec" does not work
    workaround is to remove the entry /usr/lib/rpm/check-rpaths from ~/.rpmmacros and re-run rpmbuild
  - powerman.spec
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/genders-ohpc-1.22-1.ohpc.1.3.6.x86_64.rpm
  - pdsh.spec
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/slurm-ohpc-18.08.8-1.ohpc.1.3.6.x86_64.rpm
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/slurm-devel-ohpc-18.08.8-1.ohpc.1.3.6.x86_64.rpm
  - hypre.spec
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/openmpi3-gnu8-ohpc-3.1.4-1.ohpc.1.3.6.x86_64.rpm
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/superlu-gnu8-ohpc-5.2.1-0.ohpc.1.3.6.x86_64.rpm
  - mumps.spec
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/scalapack-gnu8-openmpi3-ohpc-2.0.2-1.ohpc.1.3.6.x86_64.rpm
  - python-scipy.spec
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/fftw-gnu8-openmpi3-ohpc-3.3.8-1.ohpc.1.3.6.x86_64.rpm
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/python3-numpy-gnu8-ohpc-1.15.4-1.ohpc.1.3.6.x86_64.rpm
    $ sudo yum install -y ~/rpmbuild/RPMS/x86_64/python3-Cython-ohpc-0.26.1-0.x86_64.rpm
    $ misc/build_rpm.sh python-scipy.spec
      NG: ModuleNotFoundError: No module named 'numpy'
    $ sudo yum -y install python36-numpy
    $ misc/build_rpm.sh python-scipy.spec
      RuntimeError: Cython not found or too old. Possibly due to `pip` being too old, found version 9.0.3, needed is >= 18.0.0.
    $ pip3 --version
      pip 9.0.3 from /usr/lib/python3.6/site-packages (python 3.6)
    NG
  - petsc.spec
    $ sudo yum -y install ~/rpmbuild/RPMS/x86_64/phdf5-gnu8-openmpi3-ohpc-1.10.5-1.ohpc.1.3.6.x86_64.rpm
    $ sudo yum -y install ~/rpmbuild/RPMS/x86_64/valgrind-ohpc-3.15.0-1.ohpc.1.3.6.x86_64.rpm
  - slepc.spec
    $ sudo yum -y install ~/rpmbuild/RPMS/x86_64/petsc-gnu8-openmpi3-ohpc-3.12.0-1.ohpc.1.3.6.x86_64.rpm
  - scorep.spec
    $ sudo yum -y install ~/rpmbuild/RPMS/x86_64/sionlib-gnu8-openmpi3-ohpc-1.7.4-1.ohpc.1.3.6.x86_64.rpm
    $ sudo yum -y install libunwind-devel
  - netcdf-cxx4.spec
    $ sudo yum -y install ~/rpmbuild/RPMS/x86_64/netcdf-gnu8-openmpi3-ohpc-4.7.1-1.ohpc.1.3.6.x86_64.rpm
  - mfem.spec
    $ sudo yum -y install ~/rpmbuild/RPMS/x86_64/hypre-gnu8-openmpi3-ohpc-2.18.1-1.ohpc.1.3.6.x86_64.rpm
    $ sudo yum -y install ~/rpmbuild/RPMS/x86_64/superlu_dist-gnu8-openmpi3-ohpc-6.1.1-1.ohpc.1.3.6.x86_64.rpm
  - scalasca.spec
    $ sudo yum -y install ~/rpmbuild/RPMS/x86_64/scorep-gnu8-openmpi3-ohpc-6.0-1.ohpc.1.3.6.x86_64.rpm
  - adios.spec
    adios-1.13.1.tar.gz: No such file or directory
    $ curl -Lo ./components/io-libs/adios/SOURCES/adios-1.13.1.tar.gz http://users.nccs.gov/~pnorbert/adios-1.13.1.tar.gz
    $ sudo yum -y install glibc-static
    $ rpmbuild -ba --define 'ohpc_version 1.3' --define 'python_family python2' python-numpy.spec

