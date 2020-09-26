#pragma once

namespace alica {
    class BasicBehaviour;

    class IBehaviourCreator {
        public:
            virtual std::shared_ptr<BasicBehaviour> createBehaviour(int64_t behaviourConfId, void* context) = 0;
    };
}
