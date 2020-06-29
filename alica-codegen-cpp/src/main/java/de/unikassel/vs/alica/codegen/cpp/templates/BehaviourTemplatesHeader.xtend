package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.IBehaviourTemplates;


class BehaviourTemplatesHeader implements IBehaviourTemplates {

    override String behaviour(Behaviour behaviour) '''
#pragma once

#include "DomainBehaviour.h"
#include "«StringUtils.capitalize(behaviour.name)»Impl.h"

namespace alica {
    class «StringUtils.capitalize(behaviour.name)»: public DomainBehaviour {
        public:
            «StringUtils.capitalize(behaviour.name)»(void* context);
            virtual void run(void* msg);
            virtual void initialiseParameters();

        private:
            «StringUtils.capitalize(behaviour.name)»Impl* impl;
    };
}
'''

    override String behaviourImpl(Behaviour behaviour) '''
#pragma once

// Forward declaration
class DomainBehaviour;

#include "DomainBehaviourImpl.h"
#include <iostream>

namespace alica {
    class «StringUtils.capitalize(behaviour.name)»Impl: public DomainBehaviourImpl {
        public:
            «StringUtils.capitalize(behaviour.name)»Impl(DomainBehaviour* domain);
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

#include "DomainCondition.h"
#include "PreCondition«behaviour.preCondition.id»Impl.h"
#include <engine/RunningPlan.h>

namespace alica {
    class PreCondition«behaviour.preCondition.id»: public DomainCondition {
        public:
            static long id;
            PreCondition«behaviour.preCondition.id»(void* context);

        private:
            PreCondition«behaviour.preCondition.id»Impl* impl;
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String preConditionBehaviourImpl(Behaviour behaviour) '''
#pragma once

#include <engine/RunningPlan.h>
#include <iostream>

namespace alica {
    class PreCondition«behaviour.preCondition.id»Impl {
        public:
            static long id;
            PreCondition«behaviour.preCondition.id»Impl();

        private:
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String runtimeConditionBehaviour(Behaviour behaviour) '''
#pragma once

#include <engine/RunningPlan.h>
#include "DomainCondition.h"
#include "RunTimeCondition«behaviour.runtimeCondition.id»Impl.h"

namespace alica {
    class RunTimeCondition«behaviour.runtimeCondition.id»: public DomainCondition {
        public:
            static long id;
            RunTimeCondition«behaviour.runtimeCondition.id»();

        private:
            RunTimeCondition«behaviour.runtimeCondition.id»Impl* impl;
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String runtimeConditionBehaviourImpl(Behaviour behaviour) '''
#pragma once

#include <engine/RunningPlan.h>
#include "DomainCondition.h"

namespace alica {
    class RunTimeCondition«behaviour.runtimeCondition.id»Impl: public DomainCondition {
        public:
            static long id;
            RunTimeCondition«behaviour.runtimeCondition.id»Impl();

        private:
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String postConditionBehaviour(Behaviour behaviour) '''
#pragma once

#include <engine/RunningPlan.h>
#include "DomainCondition.h"
#include "PostCondition«behaviour.postCondition.id»Impl.h"

namespace alica {
    class PostCondition«behaviour.postCondition.id»: public DomainCondition {
        public:
            static long id;
            PostCondition«behaviour.postCondition.id»(void* context);

        private:
            PostCondition«behaviour.postCondition.id»Impl* impl;
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String postConditionBehaviourImpl(Behaviour behaviour) '''
#pragma once

#include <engine/RunningPlan.h>

namespace alica {
    class PostCondition«behaviour.postCondition.id»Impl {
        public:
            static long id;
            PostCondition«behaviour.postCondition.id»Impl();

        private:
            bool evaluate(RunningPlan* rp);
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

#include "Constraint«behaviour.preCondition.id»Impl.h"
#include <engine/BasicConstraint.h>
#include <engine/RunningPlan.h>
#include <engine/ProblemDescriptor.h>

namespace alica {
    class Constraint«behaviour.preCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«behaviour.preCondition.id»();

        private:
            Constraint«behaviour.preCondition.id»Impl* impl;
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);
    }
};
'''

    override String constraintPreConditionImpl(Behaviour behaviour) '''
#pragma once

#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«behaviour.preCondition.id»Impl {
        public:
            static long id;
            Constraint«behaviour.preCondition.id»Impl();

        private:
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);
    };
}
'''

    override String constraintRuntimeCondition(Behaviour behaviour) '''
#pragma once

#include "Constraint«behaviour.runtimeCondition.id»Impl.h"
#include <engine/BasicConstraint.h>
#include <engine/RunningPlan.h>
#include <engine/ProblemDescriptor.h>

namespace alica {
    class Constraint«behaviour.runtimeCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«behaviour.runtimeCondition.id»();

        private:
            Constraint«behaviour.runtimeCondition.id»Impl* impl;
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);
    }
};
'''

    override String constraintRuntimeConditionImpl(Behaviour behaviour) '''
#pragma once

#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«behaviour.runtimeCondition.id»Impl {
        public:
            static long id;
            Constraint«behaviour.runtimeCondition.id»Impl();

        private:
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);
    };
}
'''

    override String constraintPostCondition(Behaviour behaviour) '''
#pragma once

#include "Constraint«behaviour.postCondition.id»Impl.h"
#include <engine/BasicConstraint.h>
#include <engine/RunningPlan.h>
#include <engine/ProblemDescriptor.h>

namespace alica {
    class Constraint«behaviour.postCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«behaviour.postCondition.id»();

        private:
            Constraint«behaviour.postCondition.id»Impl* impl;
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);
    }
};
'''

    override String constraintPostConditionImpl(Behaviour behaviour) '''
#pragma once

#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«behaviour.postCondition.id»Impl {
        public:
            static long id;
            Constraint«behaviour.postCondition.id»Impl();

        private:
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);
    };
}
'''

}
