package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplatesHeader implements IDomainTemplates {

    override String domainBehaviour() '''
#pragma once

#include <engine/BasicBehaviour.h>

namespace alica {
    class DomainBehaviourImpl;

    class DomainBehaviour: public BasicBehaviour {
        public:
            DomainBehaviour(std::string name, long id, void* context);
            virtual ~DomainBehaviour();
            void* getContext();
            long getOwnId();

        protected:
            long id;
            void* context;
            DomainBehaviourImpl* impl;
    };
}
'''

    override String domainBehaviourImpl() '''
#pragma once

namespace alica {
    class DomainBehaviour;

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

namespace alica {
    class DomainConditionImpl;

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

namespace alica {
    class DomainBehaviour;

    class RunningPlan;

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
