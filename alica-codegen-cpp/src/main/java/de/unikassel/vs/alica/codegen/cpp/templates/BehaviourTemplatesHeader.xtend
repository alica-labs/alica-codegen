package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.IBehaviourTemplates;


class BehaviourTemplatesHeader implements IBehaviourTemplates {

    override String behaviour(Behaviour behaviour) '''
#pragma once

#include <memory>
#include "domain/DomainBehaviour.h"

namespace alica {
    class «StringUtils.capitalize(behaviour.name)»Impl;

    class «StringUtils.capitalize(behaviour.name)»: public DomainBehaviour {
        public:
            «StringUtils.capitalize(behaviour.name)»(void* context);
            virtual void run(void* msg);
            virtual void initialiseParameters();

        private:
            std::shared_ptr<«StringUtils.capitalize(behaviour.name)»Impl> impl;
    };
}
'''

    override String behaviourImpl(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <iostream>
#include "domain/DomainBehaviourImpl.h"

namespace alica {
    class DomainBehaviour;

    class «StringUtils.capitalize(behaviour.name)»Impl: public DomainBehaviourImpl {
        public:
            «StringUtils.capitalize(behaviour.name)»Impl(std::shared_ptr<DomainBehaviour> domain);
            virtual void run(void* msg);
            virtual void initialiseParameters();
    };
}
'''

    override String behaviourCondition(Behaviour behaviour) '''
#pragma once

namespace alica {
    class «StringUtils.capitalize(behaviour.name)»«behaviour.id» {
        public:
            static long id;
    };
}
'''

    override String preConditionBehaviour(Behaviour behaviour) '''
#pragma once

#include <memory>
#include "domain/DomainCondition.h"

namespace alica {
    class PreCondition«behaviour.preCondition.id»Impl;

    class RunningPlan;

    class PreCondition«behaviour.preCondition.id»: public DomainCondition {
        public:
            static long id;
            PreCondition«behaviour.preCondition.id»(void* context);

        private:
            std::shared_ptr<PreCondition«behaviour.preCondition.id»Impl> impl;
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String preConditionBehaviourImpl(Behaviour behaviour) '''
#pragma once

#include <memory>

namespace alica {
    class RunningPlan;

    class PreCondition«behaviour.preCondition.id»Impl {
        public:
            static long id;
            PreCondition«behaviour.preCondition.id»Impl();

        private:
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String runtimeConditionBehaviour(Behaviour behaviour) '''
#pragma once

#include <memory>
#include "conditions/RunTimeCondition«behaviour.runtimeCondition.id»Impl.h"
#include "domain/DomainCondition.h"
#include <engine/RunningPlan.h>

namespace alica {
    class RunTimeCondition«behaviour.runtimeCondition.id»: public DomainCondition {
        public:
            static long id;
            RunTimeCondition«behaviour.runtimeCondition.id»();

        private:
            std::shared_ptr<RunTimeCondition«behaviour.runtimeCondition.id»Impl> impl;
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String runtimeConditionBehaviourImpl(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <engine/RunningPlan.h>
#include "domain/DomainCondition.h"

namespace alica {
    class RunTimeCondition«behaviour.runtimeCondition.id»Impl: public DomainCondition {
        public:
            static long id;
            RunTimeCondition«behaviour.runtimeCondition.id»Impl();

        private:
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String postConditionBehaviour(Behaviour behaviour) '''
#pragma once

#include <memory>
#include "conditions/PostCondition«behaviour.postCondition.id»Impl.h"
#include "domain/DomainCondition.h"
#include <engine/RunningPlan.h>

namespace alica {
    class PostCondition«behaviour.postCondition.id»: public DomainCondition {
        public:
            static long id;
            PostCondition«behaviour.postCondition.id»(void* context);

        private:
            std::shared_ptr<PostCondition«behaviour.postCondition.id»Impl> impl;
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String postConditionBehaviourImpl(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <engine/RunningPlan.h>

namespace alica {
    class PostCondition«behaviour.postCondition.id»Impl {
        public:
            static long id;
            PostCondition«behaviour.postCondition.id»Impl();

        private:
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String constraints(Behaviour behaviour) '''
#pragma once

namespace alica {
    class «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints {
        public:
            static long id;
    };
}
'''

    override String constraintPreCondition(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <engine/BasicConstraint.h>

namespace alica {
    class Constraint«behaviour.preCondition.id»Impl;

    class ProblemDescriptor;

    class RunningPlan;

    class Constraint«behaviour.preCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«behaviour.preCondition.id»();

        private:
            std::shared_ptr<Constraint«behaviour.preCondition.id»Impl> impl;
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    }
};
'''

    override String constraintPreConditionImpl(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«behaviour.preCondition.id»Impl {
        public:
            static long id;
            Constraint«behaviour.preCondition.id»Impl();

        private:
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String constraintRuntimeCondition(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <engine/BasicConstraint.h>

namespace alica {
    class Constraint«behaviour.runtimeCondition.id»Impl;

    class ProblemDescriptor;

    class RunningPlan;

    class Constraint«behaviour.runtimeCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«behaviour.runtimeCondition.id»();

        private:
            std::shared_ptr<Constraint«behaviour.runtimeCondition.id»Impl> impl;
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    }
};
'''

    override String constraintRuntimeConditionImpl(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«behaviour.runtimeCondition.id»Impl {
        public:
            static long id;
            Constraint«behaviour.runtimeCondition.id»Impl();

        private:
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String constraintPostCondition(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <engine/BasicConstraint.h>

namespace alica {
    class Constraint«behaviour.postCondition.id»Impl;

    class ProblemDescriptor;

    class RunningPlan;

    class Constraint«behaviour.postCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«behaviour.postCondition.id»();

        private:
            std::shared_ptr<Constraint«behaviour.postCondition.id»Impl> impl;
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    }
};
'''

    override String constraintPostConditionImpl(Behaviour behaviour) '''
#pragma once

#include <memory>
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«behaviour.postCondition.id»Impl {
        public:
            static long id;
            Constraint«behaviour.postCondition.id»Impl();

        private:
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    };
}
'''

}
