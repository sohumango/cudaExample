#include <stdio.h> 
#include <time.h>

#define WIDTH 1024 

float h_A[WIDTH * WIDTH];
float h_B[WIDTH * WIDTH];
float h_C[WIDTH * WIDTH]; 

void h_multiply(float *A, float *B, float *C); 

int main()
{
    unsigned int i;
    clock_t s1,e1;
    s1 = clock();
    for (i = 0; i < (WIDTH * WIDTH); i++) {
        h_A[i] = (float)i;
        h_B[i] = (float)i;
    }
    e1 = clock();
    printf("init cost = %f\n", ((double) (e1 - s1)) / CLOCKS_PER_SEC);

    clock_t start, end;
    double cpu_time_used;
    start = clock();
    h_multiply(h_A, h_B, h_C);
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    printf("host result: %f, time cost = %f second\n", h_C[WIDTH * WIDTH - 1], cpu_time_used);
    return 0;
}

void h_multiply(float *A, float *B, float *C)
{
    unsigned int r, c, i;
    float tmp;
    for (r = 0; r < WIDTH; r++) {
        for (c = 0; c < WIDTH; c++) {
            tmp = 0.0;
            for(i = 0; i < WIDTH; i++)
                tmp += A[WIDTH * r + i] * B[WIDTH * i + c];
            C[WIDTH * r + c] = tmp;
        }
    }
}
