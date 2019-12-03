function build(){
    aa=`nvcc --version 2>/dev/null`
    bb=`gcc --version 2>/dev/null`
    if [ -z "$aa" ] && [ -z "$bb" ]; then
        echo "no gcc and nvcc"
    fi
    if [ ! -z "$aa" ]; then
        nvcc c1.cu -o gpu_c1
        ./gpu_c1
        nvcc c2.cu -o gpu_c2
        ./gpu_c2
    fi
    if [ ! -z "$bb" ]; then
        gcc m1.c -o cpu_m1
        ./cpu_m1
        gcc m2.c -o cpu_m2
        ./cpu_m2
    fi
}
if [ "$1" == "clean" ];then
    rm -rf cpu_m*
    rm -rf gpu_c*
else
build
fi