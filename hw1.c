#include "m_pd.h"
 
typedef struct hw1
{
  t_object x_ob;
  t_outlet *x_outlet;
  float x_value;
  float x2_value;

} t_hw1;

void hw1_float(t_hw1 *x,t_floatarg f)
{
    post("what is %f mod by %f?\n",f,x->x_value);
    x->x2_value = f;
    int f_to_int = (int)f;
    int xval_to_int = (int)x->x_value;
    int mod = f_to_int % xval_to_int;
    float mod_to_float = (float)mod;
    post("answer: %d\n", mod);
    outlet_float(x->x_outlet,mod_to_float);
    
}

void hw1_ft1(t_hw1 *x, t_floatarg g)
{
    post("what is %f mod by %f?\n",x->x2_value,g); 
    x->x_value = g;
    float temp = x->x2_value/g;
    int g_to_int = (int)g;
    int x2val_to_int = (int)x->x2_value;
    int mod = x2val_to_int % g_to_int;
    int mod_to_float = (float)mod;
    post("answer: %d\n", mod);
    outlet_float(x->x_outlet,mod_to_float);
    
}

t_class *hw1_class;

void *hw1_new(void)
{
    t_hw1 *x = (t_hw1 *)pd_new(hw1_class);
    inlet_new(&x->x_ob, &x->x_ob.ob_pd, gensym("float"), gensym("ft1"));
    x->x_outlet = outlet_new(&x->x_ob, gensym("float"));
    return (void *)x;
}

void hw1_setup(void)
{
    hw1_class = class_new(gensym("hw1"), (t_newmethod)hw1_new,
    	0, sizeof(t_hw1), 0, 0);
    class_addmethod(hw1_class, (t_method)hw1_ft1, gensym("ft1"),A_FLOAT, 0);
    class_addfloat(hw1_class,hw1_float);

}