package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.RuntimeCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
import de.unikassel.vs.alica.planDesigner.alicamodel.State;
import de.unikassel.vs.alica.planDesigner.alicamodel.Variable;
import java.util.List;
import org.apache.commons.lang3.StringUtils;


class TransitionTemplates {

    def String constraintPlanTransitionPreCondition(Plan plan, Transition transition) '''
package de.uniks.vs.alica.code.gen.constraints;

import de.uniks.vs.alica.engine.BasicConstraint;
import de.uniks.vs.alica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.impl.Constraint«transition.preCondition.id»Impl;

public class Constraint«transition.preCondition.id» extends BasicConstraint {
    private Constraint«transition.preCondition.id»Impl impl;

    public Constraint«transition.preCondition.id»() {
        super();
        impl = new Constraint«transition.preCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
«««        «var List<State> states = plan.states»
«««        «FOR state: states»
«««            «var List<Transition> outTransitions = state.outTransitions»
«««            «FOR outTransition: outTransitions»
«««                «IF outTransition.preCondition !== null»
«««                     «var List<Variable> variables = outTransition.preCondition.variables»
«««                     «IF (outTransition.preCondition !== null && outTransition.preCondition.pluginName == "DefaultPlugin" && variables.size > 0)»
            impl.getConstraint(c, rp);
«««                     «ENDIF»
«««                 «ENDIF»
«««             «ENDFOR»
«««         «ENDFOR»
    }
}
'''

def String constraintPlanTransitionPreConditionImpl(Transition transition) '''
package de.uniks.vs.alica.code.impl.constraints;

import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;

public class Constraint«transition.preCondition.id»Impl {
    public Constraint«transition.preCondition.id»Impl() { }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) { }
}
'''

    def String transitionPreConditionPlan(State state, Transition transition) '''
package de.uniks.vs.alica.code.gen.conditions;

import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.gen.domain.DomainCondition;
import de.uniks.vs.alica.code.impl.conditions.PreCondition«transition.preCondition.id»Impl;

public class PreCondition«transition.preCondition.id» extends DomainCondition {

    static long id = «transition.preCondition.id»L;

    private PreCondition«transition.preCondition.id»Impl impl;

    public PreCondition«transition.preCondition.id»(Object context) {
        super(context);
        impl = new PreCondition«transition.preCondition.id»Impl(this);
    }

    public boolean evaluate(RunningPlan rp) {
        return impl.evaluate(rp);
«««         boolean result = true;
«««         «var List<Transition> outTransitions = state.outTransitions»
«««         «FOR outTransition: outTransitions»
«««             «IF (outTransition.preCondition !== null && outTransition.preCondition.pluginName == "DefaultPlugin")»
«««                 if (!impl.evaluate(rp)) {
«««                     result = false;
«««                }
«««             «ENDIF»
«««         «ENDFOR»
«««         return result;
    }
}
'''

}
