#pragma once

namespace alica {
    class Plan;

    class UtilityFunction;

    class BasicUtilityFunction {
        virtual std::shared_ptr<UtilityFunction> getUtilityFunction(Plan* plan) = 0;
    };
}
