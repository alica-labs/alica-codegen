package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplatesHeader implements IDomainTemplates {

    override String domainBehaviour() '''
#pragma once

#include <memory>
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
            std::shared_ptr<DomainBehaviourImpl> impl;
    };
}
'''

    override String domainBehaviourImpl() '''
#pragma once

#include <memory>

namespace alica {
    class DomainBehaviour;

    class DomainBehaviourImpl {
        public:
            DomainBehaviourImpl(std::shared_ptr<DomainBehaviour> domain);
            virtual void run(void* msg);
            virtual void initialiseParameters();

        protected:
            std::shared_ptr<DomainBehaviour> domain;
    };
}
'''

    override String domainCondition() '''
#pragma once

#include <memory>
#include <engine/BasicCondition.h>

namespace alica {
    class DomainConditionImpl;

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

#include <memory>

namespace alica {
    class DomainBehaviour;

    class RunningPlan;

    class DomainConditionImpl {
        public:
            DomainConditionImpl();
            bool evaluate(std::shared_ptr<RunningPlan> rp);

        protected:
            std::shared_ptr<DomainBehaviour> domain;
    };
}
'''

}
