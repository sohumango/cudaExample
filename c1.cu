#include <stdio.h>
#include<stdlib.h>

dim3 grid(10, 10);
dim3 block(10,10,1);

#define BLOCK 16
#define N 200

__global__
void sum_of_array(float *arr1, float *arr2, float *arr3){
    printf("blockIdx.x = %d, blockIdx.y = %d, blockIdx.z = %d\n", blockIdx.x, blockIdx.y, blockIdx.z);
    printf("threadIdx.x = %d\n", threadIdx.x);

    int i = blockIdx.x * blockDim.x + threadIdx.x;
    arr3[i] = arr1[i] + arr2[i];
}

void initialize_array(float *arr, int size){
    for (int i = 0; i < size; i++){
        arr[i] = i*1.0;//(float)rand();
    }
}

int main(void){
    float *arr1, *arr2, *arr3, *d_arr1, *d_arr2, *d_arr3;
    size_t n_byte = N * sizeof(float);

    arr1 = (float *)malloc(n_byte);
    arr2 = (float *)malloc(n_byte);
    arr3 = (float *)malloc(n_byte);

    initialize_array(arr1, N);
    initialize_array(arr2, N);
    initialize_array(arr3, N);

    printf("start cudaMalloc\n");
    cudaMalloc((void**)&d_arr1, n_byte);
    cudaMalloc((void**)&d_arr2, n_byte);
    cudaMalloc((void**)&d_arr3, n_byte);
    printf("finish cudaMalloc\n");

    printf("start cudaMemcpy\n");
    cudaMemcpy(d_arr1, arr1, n_byte, cudaMemcpyHostToDevice);
    cudaMemcpy(d_arr2, arr2, n_byte, cudaMemcpyHostToDevice);
    cudaMemcpy(d_arr3, arr3, n_byte, cudaMemcpyHostToDevice);
    printf("finish cudaMemcpy\n");

    printf("start kernel function\n");
    sum_of_array<<<(N+255)/256, 256>>>(d_arr1, d_arr2, d_arr3);
    printf("finish kernel function\n");
    cudaMemcpy(arr3, d_arr3, n_byte, cudaMemcpyDeviceToHost);
    cudaFree(d_arr3);
    cudaFree(d_arr2);
    cudaFree(d_arr1);

    for(int i = 0; i <N; i++){
        printf("%f+%f = %f, ", arr1[i], arr2[i], arr3[i]);
    }
    printf("\n");
}