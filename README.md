# AscendC samples

[AscendC devkit link](https://gitcode.com/cann/asc-devkit/blob/master/examples/01_simd_cpp_api/00_introduction/01_add/basic_api_memory_allocator_add/add.asc)

# ascend_c_addn Operator direct dispatch example
This example is based on the addn operator project and describes how to directly debug a single operator <<<>>>. This example supports dynamic addition of two tensors. The ListTensorDesc structure is used to flexibly process multiple input parameters, implementing efficient and scalable kernel function calls.

## Supported Products
- Atlas A3 Training series products / Atlas A3 inference series products
- Atlas A2 Training series products/Atlas A2 inference series products

## Operator development based on a one-stop operator development platform.
Quickly complete operator creation, development, exception detection, and performance optimization based on a one-stop operator development platform.
Instruction Manual：**[https://gitcode.com/org/cann/discussions/54](https://gitcode.com/org/cann/discussions/54)**

## Compile and run

How to quickly compile operators
| Mode | Command | Purpose |
|------|------|------|
| Regular Compilation | `bash build.sh` | Daily Development Verification |
| anomaly detection | `bash build.sh --mssanitizer` | Problem Detection |
| Upper board tuning | `bash build.sh --onboard` | Performance analysis in real environments |
| Simulation Optimization | `bash build.sh --simulator` | Instruction-level detailed analysis |

## Operator Description
- Operator Functionality：  

This operator implements the function of adding two pieces of data and returning the result of the addition. The input parameters of the kernel function are dynamic inputs, which include two input parameters: x and y. The corresponding mathematical expression is as follows：  
  ```
  z = x + y
  ```
- Operator Specifications：
  <table>
  </tr>
  <tr><td rowspan="3" align="center">Operator Input</td><td align="center">name</td><td align="center">shape</td><td align="center">data type</td><td align="center">format</td></tr>
  <tr><td align="center">x（Dynamic Input Parameters srcList[0]）</td><td align="center">8 * 2048</td><td align="center">float</td><td align="center">ND</td></tr>
  <tr><td align="center">y（Dynamic Input Parameters srcList[1]）</td><td align="center">8 * 2048</td><td align="center">float</td><td align="center">ND</td></tr>
  </tr>
  </tr>
  <tr><td rowspan="1" align="center">Operator output</td><td align="center">z</td><td align="center">8 * 2048</td><td align="center">float</td><td align="center">ND</td></tr>
  </tr>
  </table>
- operator implementation：  

  The dynamic input feature indicates that the input data information of the kernel function is stored in the ListTensorDesc structure.
  The following is an example of constructing the TensorList data structure.
  ```cpp
  constexpr uint32_t SHAPE_DIM = 2;
    struct TensorDesc {
      uint32_t dim{SHAPE_DIM};
      uint32_t index;
      uint64_t shape[SHAPE_DIM] = {8, 2048};
    };

  constexpr uint32_t TENSOR_DESC_NUM = 2;
    struct ListTensorDesc {
      uint64_t ptrOffset;
      TensorDesc tensorDesc[TENSOR_DESC_NUM];
      uintptr_t dataPtr[TENSOR_DESC_NUM];
    } inputDesc;
  ```
  The input parameters of the allocated tensor are combined into the data structure of ListTensorDesc. The following is an example:
  ```cpp
  inputDesc = {(1 + (1 + SHAPE_DIM) * TENSOR_DESC_NUM) * sizeof(uint64_t),
              {xDesc, yDesc},
              {(uintptr_t)xDevice, (uintptr_t)yDevice}};
  ``` 
  The corresponding input parameters are parsed based on the input data format. The following is an example:

  ```cpp
  uint64_t buf[SHAPE_DIM] = {0};
  AscendC::TensorDesc<int32_t> tensorDesc;
  tensorDesc.SetShapeAddr(buf);
  listTensorDesc.GetDesc(tensorDesc, 0);
  uint64_t totalLength = tensorDesc.GetShape(0) * tensorDesc.GetShape(1);
  __gm__ uint8_t *x = listTensorDesc.GetDataPtr<__gm__ uint8_t>(0);
  __gm__ uint8_t *y = listTensorDesc.GetDataPtr<__gm__ uint8_t>(1);
  ```
  - Invocation implementation  
    Use the kernel invocation operator <<<>>> to invoke a kernel function.
