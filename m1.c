#include <stdio.h>
#include<stdlib.h>

#define N 20


void initialize_array(float *arr, int size){
    for (int i = 0; i < size; i++){
        arr[i] = (float)rand();
        printf("arr[%d] = %.2f, ",i, arr[i]);
    }
    printf("\n\n");
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

    printf("%d,%zu\n", N, n_byte);
}