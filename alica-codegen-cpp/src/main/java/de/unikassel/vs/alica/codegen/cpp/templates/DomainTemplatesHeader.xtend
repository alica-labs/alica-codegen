package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplatesHeader implements IDomainTemplates {

    override String domainBehaviour() '''
#pragma once

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
            std::shared_ptr<DomainBehaviourImpl> impl;
    };
}
'''

    override String domainBehaviourImpl() '''
#pragma once

#include "DomainBehaviour.h"

namespace alica {
    class DomainBehaviourImpl {
        public:
            DomainBehaviourImpl(std::shared_ptr<DomainBehaviour> domain);
            void run(void* msg);
            void initialiseParameters();

        protected:
            std::shared_ptr<DomainBehaviour> domain;
    };
}
'''

    override String domainCondition() '''
#pragma once

#include <engine/BasicCondition.h>

namespace alica {
    class DomainCondition: public BasicCondition {
        public:
            DomainCondition(void* context);
            virtual ~DomainCondition();

        private:
            std::shared_ptr<DomainConditionImpl> impl;
    };
}
'''

    override String domainConditionImpl() '''
#pragma once

namespace alica {
    class DomainConditionImpl {
        public:
            DomainConditionImpl();
            boolean evaluate(std::shared_ptr<RunningPlan> rp);

        protected:
            std::shared_ptr<DomainBehaviour> domain;
    };
}
'''

}
