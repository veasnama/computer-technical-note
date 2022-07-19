## What is a functional language?

- A functioanl language: 
1. defines a computation as  mathematical functions
2. avoids mutable state
---
- State:
the information maintained by a computation
- You're used to maintaining state say for example
you're building a linked list class in Java it maintains information perhaps maybe how many elements are within the list or which node at the beginning or at the end of the list that's the state that's maintained 

- Mutable State: A state that can be changed. 
One instant of a computation a state is one thing and another instant in a computation the state has evolved and changed that change is the essence of mutability 
change 
## Imperatives Programming 

- Commands specify how to compute by destructively changing state

```
x = x + 1
array[0] = 40
p.next = p.next.next
```
- Functions/Methods have side effects:
```
int x = 0;

int incre_x() {
    x++;
    return x;

}

```
## Functional Programming 
- Expressions specify what to compute 
- Variables never change value 
- Functions never have side effect.


## The reality of immutability 
- No need to think about state
- Powerful way to build correct programs 

