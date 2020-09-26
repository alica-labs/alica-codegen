#pragma once

namespace alica {
    class BasicConstraint;

    class IConstraintCreator {
        public:
            virtual std::shared_ptr<BasicConstraint> createConstraint(int64_t constraintConfId) = 0;
    };
}
