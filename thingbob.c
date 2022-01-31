#include "m_pd.h"
 
typedef struct thingbob
{
  t_object x_ob;
  t_outlet *x_outlet;
  float x_value;
} t_thingbob;

void thingbob_float(t_thingbob *x, t_floatarg f)
{
    outlet_float(x->x_outlet, f + x->x_value);
}

void thingbob_ft1(t_thingbob *x, t_floatarg g)
{
    x->x_value = g;
}

t_class *thingbob_class;

void *thingbob_new(void)
{
    t_thingbob *x = (t_thingbob *)pd_new(thingbob_class);
    inlet_new(&x->x_ob, &x->x_ob.ob_pd, gensym("float"), gensym("ft1"));
    x->x_outlet = outlet_new(&x->x_ob, gensym("float"));
    return (void *)x;
}

void thingbob_setup(void)
{
    thingbob_class = class_new(gensym("thingbob"), (t_newmethod)thingbob_new,
    	0, sizeof(t_thingbob), 0, 0);
    class_addmethod(thingbob_class, (t_method)thingbob_ft1, gensym("ft1"), A_FLOAT, 0);
    class_addfloat(thingbob_class, thingbob_float);
}