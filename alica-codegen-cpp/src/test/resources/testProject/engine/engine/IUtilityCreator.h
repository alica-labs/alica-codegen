#pragma once

namespace alica {
    class BasicUtilityFunction;

    class IUtilityCreator {
        public:
            virtual std::shared_ptr<BasicUtilityFunction> createUtility(int64_t utilityFunctionConfId) = 0;
    };
}
