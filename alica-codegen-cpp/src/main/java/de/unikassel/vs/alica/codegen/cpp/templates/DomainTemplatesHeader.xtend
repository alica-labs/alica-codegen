package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplatesHeader implements IDomainTemplates {

    override String domainBehaviour() '''
#pragma once

#include "DomainBehaviourImpl.h"
#include <engine/BasicBehaviour.h>
#include <string>

namespace alica {
    class DomainBehaviour: public BasicBehaviour {
        public:
            DomainBehaviour(std::string name, long id, void* context);
            virtual ~DomainBehaviour();
            void* getContext();
            long getOwnId();

        private:
            long id;
            void* context;
            DomainBehaviourImpl* impl;
    };
}
'''

    override String domainBehaviourImpl() '''
#pragma once

// Forward declaration
struct DomainBehaviour {
    long getOwnId();
};

namespace alica {
    class DomainBehaviourImpl {
        public:
            DomainBehaviourImpl(DomainBehaviour* domain);
            virtual void run(void* msg);
            virtual void initialiseParameters();

        protected:
            DomainBehaviour* domain;
    };
}
'''

    override String domainCondition() '''
#pragma once

#include <engine/BasicCondition.h>
#include "DomainConditionImpl.h"

namespace alica {
    class DomainCondition: public BasicCondition {
        public:
            DomainCondition(void* context);
            virtual ~DomainCondition();

        private:
            DomainConditionImpl* impl;
    };
}
'''

    override String domainConditionImpl() '''
#pragma once

// Forward declaration
class DomainBehaviour;

#include <engine/RunningPlan.h>
#include <iostream>

namespace alica {
    class DomainConditionImpl {
        public:
            DomainConditionImpl();
            bool evaluate(RunningPlan* rp);

        protected:
            DomainBehaviour* domain;
    };
}
'''

}
