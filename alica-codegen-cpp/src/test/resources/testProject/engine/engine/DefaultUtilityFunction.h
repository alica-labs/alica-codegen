#pragma once

#include "engine/UtilityFunction.h"

namespace alica {
    class Plan;

    class DefaultUtilityFunction: public UtilityFunction {
        public:
            DefaultUtilityFunction(Plan* plan) {};
    };
}
