#pragma once

#include "BasicPlan.h"
#include "UtilityFunction.h"

class DefaultUtilityFunction: public UtilityFunction {
    public:
        DefaultUtilityFunction(BasicPlan* plan);
};
