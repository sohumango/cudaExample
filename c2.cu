#include <stdio.h>
#include <cuda_runtime.h>

#define BLOCK 16
#define WIDTH 1024

float h_A[WIDTH * WIDTH];
float h_B[WIDTH * WIDTH];
float h_C[WIDTH * WIDTH]; 

float *d_A, *d_B, *d_C;

__global__ void d_multiply0(float *A, float *B, float *C)
{
    unsigned int r = blockDim.y * blockIdx.y + threadIdx.y;
    unsigned int c = blockDim.x * blockIdx.x + threadIdx.x;
    unsigned int i;
    float tmp;
    tmp = 0.0f;
    if ((r < WIDTH) && (c < WIDTH)) { 
        for (i = 0; i < WIDTH; i++)
            tmp += A[WIDTH * r + i] * B[WIDTH * i + c];
        C[WIDTH * r + c] = tmp;
    }
}

int main()
{
    unsigned int i;
    clock_t s1, e1;
    s1 = clock();
    for (i = 0; i < (WIDTH * WIDTH); i++) {
        h_A[i] = (float)i;
        h_B[i] = (float)i;
    }
    e1 = clock();
    printf("set value cost =%f\n", ((double) (e1 - s1)) / CLOCKS_PER_SEC);

    s1 = clock();
    cudaMalloc((void**)&d_A, sizeof(float) * WIDTH * WIDTH);
    e1 = clock();
    printf("cudaMalloc_1 cost =%f\n", ((double) (e1 - s1)) / CLOCKS_PER_SEC);
    s1 = clock();
    cudaMalloc((void**)&d_B, sizeof(float) * WIDTH * WIDTH);
    cudaMalloc((void**)&d_C, sizeof(float) * WIDTH * WIDTH);
    e1 = clock();
    printf("cudaMalloc_2_3 cost =%f\n", ((double) (e1 - s1)) / CLOCKS_PER_SEC);

    s1 = clock();
    cudaMemcpy(d_A, h_A, sizeof(float) * WIDTH * WIDTH, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, sizeof(float) * WIDTH * WIDTH, cudaMemcpyHostToDevice);
    e1 = clock();
    printf("cudaMemcpy cost =%f\n", ((double) (e1 - s1)) / CLOCKS_PER_SEC);

    dim3 grid(WIDTH / BLOCK + 1, WIDTH / BLOCK + 1);
    dim3 block(BLOCK, BLOCK);

    clock_t start, end;
    double cpu_time_used;
    start = clock();
    d_multiply0 <<< grid, block >>> (d_A, d_B, d_C);
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    s1 = clock();
    cudaMemcpy(h_C, d_C, sizeof(float) * WIDTH * WIDTH, cudaMemcpyDeviceToHost);
    e1 = clock();
    printf("cudaMemcpy2 cost =%f\n", ((double) (e1 - s1)) / CLOCKS_PER_SEC);

    s1 = clock();
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    e1 = clock();
    printf("cudaFree cost =%f\n", ((double) (e1 - s1)) / CLOCKS_PER_SEC);

    printf("　device result: %f, time cost = %f second\n", h_C[WIDTH * WIDTH - 1], cpu_time_used);
    return 0;
}
