#pragma once

#include "engine/UtilityFunction.h"

namespace alica {
    class BasicPlan;

    class DefaultUtilityFunction: public UtilityFunction {
        public:
            DefaultUtilityFunction(BasicPlan* plan) {};
    };
}
