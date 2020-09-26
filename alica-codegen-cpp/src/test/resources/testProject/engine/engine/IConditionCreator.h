#pragma once

namespace alica {
    class BasicCondition;

    class IConditionCreator {
        public:
            virtual std::shared_ptr<BasicCondition> createConditions(int64_t conditionConfId, void* context) = 0;
    };
}
