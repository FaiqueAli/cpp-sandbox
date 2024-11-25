#include <iostream>
#include "../arithmetic_ops/arithmetic_ops.h"
#include "../input_handler/input_handler.h"

using namespace std;

int main() {
    int a = getInputA();
    int b = getInputB();
    char op = getOperator();

    cout << "Value getInputA()!"<< getInputA() << endl; 
    cout << "Value getInputB()!"<< getInputB() << endl; 

    int result;
    switch(op) {
        case '+': result = add(a, b); break;
        case '-': result = subtract(a, b); break;
        case '*': result = multiply(a, b); break;
        case '/': result = divide(a, b); break;
        default: 
            cout << "Invalid operator!" << endl;
            return 1;
    }

    cout << "Result: " << result << endl;
    return 0;
}
