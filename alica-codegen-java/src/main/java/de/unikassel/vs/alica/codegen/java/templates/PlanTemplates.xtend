package de.unikassel.vs.alica.codegen.java.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.IPlanTemplates;


class PlanTemplates implements IPlanTemplates {

    override String constraints(Plan plan) '''
«IF (plan.relativeDirectory.isEmpty)»
    package de.uniks.vs.alica.code.gen.constraints;
«ELSE»
    package de.uniks.vs.alica.code.gen.«plan.relativeDirectory».constraints;
«ENDIF»

/*
 * Constraints - («StringUtils.capitalize(plan.name)»): «plan.id»
 */
public class «StringUtils.capitalize(plan.name)»«plan.id»Constraints {
    static long id = «plan.id»L;
}
'''

    override String constraintPlanPreCondition(Plan plan) '''
package de.uniks.vs.alica.code.gen.constraints;

import de.uniks.vs.jalica.engine.BasicConstraint;
import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.impl.constraints.Constraint«plan.preCondition.id»Impl;

/*
 * PreCondition («StringUtils.capitalize(plan.name)»:«plan.id»): «plan.preCondition.id»
 */
public class Constraint«plan.preCondition.id» extends BasicConstraint {
    static long id = «plan.preCondition.id»L;

    private Constraint«plan.preCondition.id»Impl impl;

    public Constraint«plan.preCondition.id»() {
        super();
        this.impl = new Constraint«plan.preCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
        this.impl.getConstraint(c, rp);
    }
}
'''

    override String constraintPlanPreConditionImpl(Plan plan) '''
package de.uniks.vs.alica.code.impl.constraints;

import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;

/*
 * Plan PreCondition («StringUtils.capitalize(plan.name)»:«plan.id»): «plan.preCondition.id»
 */
public class Constraint«plan.preCondition.id»Impl {
    static long id = «plan.preCondition.id»L;

    public Constraint«plan.preCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    override String constraintPlanRuntimeCondition(Plan plan) '''
package de.uniks.vs.alica.code.gen.constraints;

import de.uniks.vs.jalica.engine.BasicConstraint;
import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.impl.constraints.Constraint«plan.runtimeCondition.id»;

/*
 * Plan RuntimeCondition («StringUtils.capitalize(plan.name)»:«plan.id»): «plan.runtimeCondition.id»
 */
public class Constraint«plan.runtimeCondition.id» extends BasicConstraint {
    static long id = «plan.runtimeCondition.id»L;

    private Constraint«plan.runtimeCondition.id»Impl impl;

    public Constraint«plan.runtimeCondition.id»() {
        super();
        this.impl = new Constraint«plan.runtimeCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
        this.impl.getConstraint(c, rp);
    }
}
'''

    override String constraintPlanRuntimeConditionImpl(Plan plan) '''
package de.uniks.vs.alica.code.impl.constraints;

import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;

/*
 * Plan RuntimeCondition («StringUtils.capitalize(plan.name)»:«plan.id»): «plan.runtimeCondition.id»
 */
public class Constraint«plan.runtimeCondition.id»Impl {
    static long id = «plan.runtimeCondition.id»L;

    public Constraint«plan.runtimeCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    override String utilityFunctionPlan(Plan plan) '''
package de.uniks.vs.alica.code.gen.utilityfunctions;

import de.uniks.vs.jalica.engine.BasicUtilityFunction;
import de.uniks.vs.jalica.engine.UtilityFunction;
import de.uniks.vs.jalica.engine.BasicPlan;

import de.uniks.vs.alica.code.impl.utilityfunctions.UtilityFunction«plan.id»Impl;

public class UtilityFunction«plan.id» extends BasicUtilityFunction {
    static long id = «plan.id»L;

    private UtilityFunction«plan.id»Impl impl;

    public UtilityFunction«plan.id»() {
        this.impl = new UtilityFunction«plan.id»Impl();
    }

    public UtilityFunction getUtilityFunction(BasicPlan plan) {
        return this.impl.getUtilityFunction(plan);
    }
}
'''

    override String utilityFunctionPlanImpl(Plan plan) '''
package de.uniks.vs.alica.code.impl.utilityfunctions;

import de.uniks.vs.jalica.engine.DefaultUtilityFunction;
import de.uniks.vs.jalica.engine.UtilityFunction;
import de.uniks.vs.jalica.engine.BasicPlan;

public class UtilityFunction«plan.id»Impl {
    static long id = «plan.id»L;

    public UtilityFunction«plan.id»Impl() {

    }

    public UtilityFunction getUtilityFunction(BasicPlan plan) {
        return new DefaultUtilityFunction(plan);
    }
}
'''

    override String preConditionPlan(Plan plan) '''
package de.uniks.vs.alica.code.gen.conditions;

import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.gen.domain.DomainCondition;
import de.uniks.vs.alica.code.impl.conditions.PreCondition«plan.preCondition.id»Impl;

public class PreCondition«plan.preCondition.id» extends DomainCondition {
    static long id = «plan.preCondition.id»L;

    private PreCondition«plan.preCondition.id»Impl impl;

    public PreCondition«plan.preCondition.id»(Object context) {
        super(context);
        this.impl = new PreCondition«plan.preCondition.id»Impl();
    }

    public boolean evaluate(RunningPlan rp) {
        return this.impl.evaluate(rp);
    }
}
'''

    override String preConditionPlanImpl(Plan plan) '''
package de.uniks.vs.alica.code.impl.conditions;

import de.uniks.vs.jalica.engine.RunningPlan;

public class PreCondition«plan.preCondition.id»Impl {
    static long id = «plan.preCondition.id»L;

    public PreCondition«plan.preCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {
        System.out.println("The PreCondition " + id + " in Plan «plan.getName» is not implement yet!");
        return false;
    }
}
'''

    override String runtimeConditionPlan(Plan plan) '''
package de.uniks.vs.alica.code.gen.conditions;

import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.gen.domain.DomainCondition;
import de.uniks.vs.alica.code.impl.conditions.RunTimeCondition«plan.runtimeCondition.id»Impl;

public class RunTimeCondition«plan.runtimeCondition.id» extends DomainCondition {
    static long id = «plan.runtimeCondition.id»L;

    private RunTimeCondition«plan.runtimeCondition.id»Impl impl;

    public RunTimeCondition«plan.runtimeCondition.id»(Object context) {
        super(context);
        this.impl = new RunTimeCondition«plan.runtimeCondition.id»Impl();
    }

    public boolean evaluate(RunningPlan rp) {
        return this.impl.evaluate(rp);
    }
}
'''

    override String runtimeConditionPlanImpl(Plan plan) '''
package de.uniks.vs.alica.code.impl.conditions;

import de.uniks.vs.jalica.engine.RunningPlan;

public class RunTimeCondition«plan.runtimeCondition.id»Impl {
    static long id = «plan.runtimeCondition.id»L;

    public RunTimeCondition«plan.runtimeCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {
        return false;
    }
}
'''

}
