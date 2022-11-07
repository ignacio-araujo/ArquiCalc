#include <stdio.h>

#define ENTRADA 10;
#define PUERTO_SALIDA_DEFECTO 1;
#define PUERTO_LOG_DEFECTO 2;

short puerto_salida = PUERTO_SALIDA_DEFECTO;
short puerto_log = PUERTO_LOG_DEFECTO;

short stack[31];
short stack_index = -1;

//------------Manejo del stack----------
void push(short w){
    stack_index++;
    stack[stack_index] = w;
}

void pop(){
    stack_index--;
}

short tope_stack(){
    return stack[stack_index];
}
//--------------------------------------

//----Implementación de in() e out()----
void in(short &w, short puerto){
    short x;
    scanf("%hd", &x);
    w = x;
}

void out(short puerto, short w){
    if(puerto == puerto_salida)
        printf("%hi ", w);
}
//--------------------------------------

short fact(short n){
    if (n == 0)
        return 1;
    else
        return n*fact(n-1);
}


int main()
{
    while(true){
        out(puerto_log, 0);
        short input;
        in(input,ENTRADA);
        out(puerto_log, input);
        switch(input){
            case 1:
            {
                short parameter;
                in(parameter,ENTRADA);
                if(stack_index == 30) out(puerto_log, 4);
                else{
                    out(puerto_log, parameter);
                    push(parameter);
                    out(puerto_log, 16);
                }
                break;
            }
            case 2:
            {
                short parameter;
                in(parameter,ENTRADA);
                puerto_salida = parameter;
                out(puerto_log, parameter);
                out(puerto_log, 16);
                break;
            }
            case 3:
            {
                short parameter;
                in(parameter,ENTRADA);
                puerto_log = parameter;
                out(puerto_log, parameter);
                out(puerto_log, 16);
                break;
            }
            case 4:
            {
                short aux = tope_stack();
                out(puerto_salida, aux);
                out(puerto_log, 16);
                break;
            }
            case 5:
            {
                short i = stack_index;
                while(i != -1){
                    out(puerto_salida, stack[i]);
                    i--;
                }
                out(puerto_log, 16);
                break;
            }
            case 6:
            {
                if(stack_index == 30) out(puerto_log, 4);
                else if(stack_index == -1){
                    out(puerto_log, 8);
                }
                else{
                    short aux = tope_stack();
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 7:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                else if(stack_index == 0){
                    out(puerto_log, 8);
                    pop();
                }
                else{
                    short aux1 = tope_stack();
                    pop();
                    short aux2 = tope_stack();
                    pop();
                    push(aux1);
                    push(aux2);
                    out(puerto_log, 16);
                }
                break;
            }
            case 8:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                else{
                    short aux = tope_stack();
                    pop();
                    //neg aux
                    aux = ~aux; //Invertimos los bits
                    aux++; //Incrementamos en uno para lograr el opuesto
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 9:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                else{
                    short tope = tope_stack();
                    pop();
                    short aux = fact(tope);
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 10:
            {
                short res = 0;
                short i = stack_index;
                while(i != -1){
                    short aux = tope_stack();
                    if(aux < 0)
                        res = res-aux;
                    else{
                        res = res+aux;
                    }
                    i--;
                    pop();
                }
                push(res);
                out(puerto_log, 16);
                break;
            }
            case 11:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    out(puerto_log, 8);
                    pop();
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1+op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 12:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    pop();
                    out(puerto_log, 8);
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1-op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 13:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    pop();
                    out(puerto_log, 8);
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1*op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 14:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    pop();
                    out(puerto_log, 8);
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1/op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 15:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    pop();
                    out(puerto_log, 8);
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1%op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 16:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    pop();
                    out(puerto_log, 8);
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1&op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 17:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    pop();
                    out(puerto_log, 8);
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1|op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 18:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    pop();
                    out(puerto_log, 8);
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1<<op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 19:
            {
                if(stack_index == -1){
                    out(puerto_log, 8);
                }
                if(stack_index == 0){
                    pop();
                    out(puerto_log, 8);
                }
                else{
                    short op2 = tope_stack();
                    pop();
                    short op1 = tope_stack();
                    pop();
                    short aux = op1>>op2;
                    push(aux);
                    out(puerto_log, 16);
                }
                break;
            }
            case 254:
            {
                short i = stack_index;
                while(i != -1){
                    pop();
                    i--;
                }
                out(puerto_log, 16);
                break;
            }
            case 255:
            {
                out(puerto_log, 16);
                Halt:
                    goto Halt;
                break;  
            }
            default:
                out(puerto_log, 16);
                break;
        }
    }

    return 0;
}