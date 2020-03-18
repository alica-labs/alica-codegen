package de.unikassel.vs.alica.codegen.java;

import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.FormatterException;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * the following line have to be "import de.unikassel.vs.alica.codegen.java.XtendTemplates;"
 * otherwise it must be inserted again!
 */
//import de.unikassel.vs.alica.codegen.java.XtendTemplates;
import de.unikassel.vs.alica.codegen.java.CreatorTemplates;
import de.unikassel.vs.alica.codegen.java.BehaviourTemplates;
import de.unikassel.vs.alica.codegen.java.DomainTemplates;
import de.unikassel.vs.alica.codegen.java.PlanTemplates;
import de.unikassel.vs.alica.codegen.java.TransitionTemplates;
import org.apache.commons.lang3.StringUtils;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;


/**
 * Code generator for Java. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerJava}.
 */
public class GeneratorImplJava extends GeneratorImpl implements IGenerator<GeneratedSourcesManagerJava> {
//    private XtendTemplates xtendTemplates;
    private CreatorTemplates creators;
    private BehaviourTemplates behaviours;
    private DomainTemplates domain;
    private PlanTemplates plans;
    private TransitionTemplates transitions;
    private GeneratedSourcesManagerJava generatedSourcesManager;
    private String implPath;
    private String genPath;

    public GeneratorImplJava() {
        creators = new CreatorTemplates();
        behaviours = new BehaviourTemplates();
        domain = new DomainTemplates();
        plans = new PlanTemplates();
        transitions = new TransitionTemplates();
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManagerJava generatedSourcesManager) {
        this.generatedSourcesManager = generatedSourcesManager;
        implPath = generatedSourcesManager.getBaseDir() + File.separator + "impl";
        genPath = generatedSourcesManager.getBaseDir() + File.separator + "gen";
    }

    @Deprecated
    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {

    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String srcPath = Paths.get(genPath + File.separator + "creators", "BehaviourCreator.java").toString();
        String fileContentSource = creators.behaviourCreator(behaviours);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void createBehaviourImpl(Behaviour behaviour) {
        String filename = StringUtils.capitalize(behaviour.getName()) + "Impl.java";
        String srcPath = Paths.get(implPath + File.separator + "behaviours", filename).toString();
        String fileContentSource = behaviours.behaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void preConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "PreCondition" + behaviour.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.preConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void preConditionCreator(Behaviour behaviour) {
        this.preConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(genPath + File.separator + "conditions", "PreCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = behaviours.preConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath+ File.separator + "conditions", "RunTimeCondition" + behaviour.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.runtimeConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void runtimeConditionCreator(Behaviour behaviour) {
        this.runtimeConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(genPath+ File.separator + "conditions", "RunTimeCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = behaviours.runtimeConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void postConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath+ File.separator + "conditions", "PostCondition" + behaviour.getPostCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.postConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void postConditionCreator(Behaviour behaviour) {
        this.postConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(genPath+ File.separator + "conditions", "PostCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = behaviours.postConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createBehaviour(Behaviour behaviour) {
        this.createBehaviourImpl(behaviour);
        if (behaviour.getPreCondition() != null) {
            this.preConditionCreator(behaviour);
        }
        if (behaviour.getRuntimeCondition() != null) {
            this.runtimeConditionCreator(behaviour);
        }
        if (behaviour.getPostCondition() != null) {
            this.postConditionCreator(behaviour);
        }

        String destinationPath = cutDestinationPathToDirectory(behaviour);
        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + ".java";
        String srcPath = Paths.get(genPath + File.separator + "behaviours", destinationPath, filename).toString();
        String fileContentSource = behaviours.behaviourCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);

        String filename2 = StringUtils.capitalize(behaviour.getName()) + ".java";
        String srcPath2 = Paths.get(genPath + File.separator + "behaviours", destinationPath, filename2).toString();
        String fileContentSource2 = behaviours.behaviour(behaviour);
        writeSourceFile(srcPath2, fileContentSource2);
        formatFile(srcPath2);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(genPath+ File.separator + "creators", "ConditionCreator.java").toString();
        String fileContentSource = creators.conditionCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(genPath+ File.separator + "creators", "ConstraintCreator.java").toString();
        String fileContentSource = creators.constraintCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPreConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath + File.separator + "conditions", "Constraint" + behaviour.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.constraintPreConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPreCondition(Behaviour behaviour) {
        this.constraintPreConditionImpl(behaviour);

        String srcPath = Paths.get(genPath + File.separator + "conditions", "Constraint" + behaviour.getPreCondition().getId() + ".java").toString();
        String fileContentSource = behaviours.constraintPreCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath + File.separator + "conditions", "Constraint" + behaviour.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.constraintRuntimeConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintRuntimeCondition(Behaviour behaviour) {
        this.constraintRuntimeConditionImpl(behaviour);

        String srcPath = Paths.get(genPath + File.separator + "conditions", "Constraint" + behaviour.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = behaviours.constraintRuntimeCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPostConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath + File.separator + "conditions", "Constraint" + behaviour.getPostCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.constraintPostConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPostCondition(Behaviour behaviour) {
        this.constraintPostConditionImpl(behaviour);

        String srcPath = Paths.get(genPath + File.separator + "conditions", "Constraint" + behaviour.getPostCondition().getId() + ".java").toString();
        String fileContentSource = behaviours.constraintPostCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintsForBehaviour(Behaviour behaviour) {
        PreCondition preCondition = behaviour.getPreCondition();
        if (preCondition != null) {
            if (preCondition.getVariables().size() > 0 || preCondition.getQuantifiers().size() > 0) {
                this.constraintPreCondition(behaviour);
            }
        }
        RuntimeCondition runtimeCondition = behaviour.getRuntimeCondition();
        if (runtimeCondition != null) {
            if (runtimeCondition.getVariables().size() > 0 || runtimeCondition.getQuantifiers().size() > 0) {
                this.constraintRuntimeCondition(behaviour);
            }
        }
        PostCondition postCondition = behaviour.getPostCondition();
        if (postCondition != null) {
            if (postCondition.getVariables().size() > 0 || postCondition.getQuantifiers().size() > 0) {
                this.constraintPostCondition(behaviour);
            }
        }

        String destinationPathWithoutName = cutDestinationPathToDirectory(behaviour);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }

        String constraintSourcePath = Paths.get(genPath, destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + "Constraints.java";
        String srcPath = Paths.get(constraintSourcePath, filename).toString();
        String fileContentSource = behaviours.constraints(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanPreConditionImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "Constraint" + plan.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.constraintPlanPreConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanPreCondition(Plan plan) {
        this.constraintPlanPreConditionImpl(plan);

        String srcPath = Paths.get(genPath, "Constraint" + plan.getPreCondition().getId() + ".java").toString();
        String fileContentSource = plans.constraintPlanPreCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanRuntimeConditionImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "Constraint" + plan.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.constraintPlanRuntimeConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanRuntimeCondition(Plan plan) {
        this.constraintPlanRuntimeConditionImpl(plan);

        String srcPath = Paths.get(genPath, "Constraint" + plan.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = plans.constraintPlanRuntimeCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String srcPath = Paths.get(implPath, "Constraint" + transition.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = transitions.constraintPlanTransitionPreConditionImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        this.constraintPlanTransitionPreConditionImpl(transition);

        String srcPath = Paths.get(genPath, "Constraint" + transition.getPreCondition().getId() + ".java").toString();
        String fileContentSource = transitions.constraintPlanTransitionPreCondition(plan, transition);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintsForPlan(Plan plan) {
        if (plan.getPreCondition() != null) {
            this.constraintPlanPreCondition(plan);
        }
        RuntimeCondition runtimeCondition = plan.getRuntimeCondition();
        if (runtimeCondition != null) {
            if (runtimeCondition.getVariables().size() > 0 || runtimeCondition.getQuantifiers().size() > 0) {
                this.constraintPlanRuntimeCondition(plan);
            }
        }
        List<Transition> transitions = plan.getTransitions();
        for (Transition transition: transitions) {
            PreCondition preCondition = transition.getPreCondition();
            if (preCondition != null) {
                if (preCondition.getVariables().size() > 0 || preCondition.getQuantifiers().size() > 0) {
                    this.constraintPlanTransitionPreCondition(plan, transition);
                }
            }
        }

        String destinationPathWithoutName = cutDestinationPathToDirectory(plan);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }

        String constraintSourcePath = Paths.get(genPath, destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + "Constraints.java";
        String srcPath = Paths.get(constraintSourcePath, filename).toString();
        String fileContentSource = plans.constraints(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);

        for (State inPlan: plan.getStates()) {
            try {
                LineNumberReader lineNumberReader = new LineNumberReader(new FileReader(srcPath));
                while (lineNumberReader.ready()) {
                    if (lineNumberReader.readLine().contains("// State: " + inPlan.getName())) {
                        generatedSourcesManager.putLineForModelElement(inPlan.getId(), lineNumberReader.getLineNumber());
                        break;
                    }
                }
                lineNumberReader.close();
            } catch (IOException e) {
                LOG.error("Could not open/read lines for " + srcPath, e);
            }
        }
    }

    private void createDomainBehaviourImpl() {
        String srcPath = Paths.get(implPath+ File.separator + "domain", "DomainBehaviourImpl.java").toString();
        String fileContentSource = domain.domainBehaviourImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();

        String srcPath = Paths.get(genPath+ File.separator + "domain", "DomainBehaviour.java").toString();
        String fileContentSource = domain.domainBehaviour();
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void createDomainConditionImpl() {
        String srcPath = Paths.get(implPath+ File.separator + "domain", "DomainConditionImpl.java").toString();
        String fileContentSource = domain.domainConditionImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();

        String srcPath = Paths.get(genPath+ File.separator + "domain", "DomainCondition.java").toString();
        String fileContentSource = domain.domainCondition();
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

//    private void createPlanImpl(Plan plan) {
//        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + "Impl.java";
//        String srcPath = Paths.get(implPath, filename).toString();
//        String fileContentSource = plans.planImpl(plan);
//        if (new File(srcPath).exists()) {
//            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
//            return;
//        }
//        writeSourceFile(srcPath, fileContentSource);
//        formatFile(srcPath);
//    }

    private void utilityFunctionPlan(Plan plan) {
        this.utilityFunctionPlanImpl(plan);

        String srcPath = Paths.get(genPath+ File.separator + "utilityfunctions", "UtilityFunction" + plan.getId() + ".java").toString();
        String fileContentSource = plans.utilityFunctionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void utilityFunctionPlanImpl(Plan plan) {
        String filename = "UtilityFunction" + plan.getId() + "Impl.java";
        String srcPath = Paths.get(implPath+ File.separator + "utilityfunctions", filename).toString();
        String fileContentSource = plans.utilityFunctionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void preConditionPlanImpl(Plan plan) {
        String srcPath = Paths.get(implPath+ File.separator + "conditions", "PreCondition" + plan.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.preConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void preConditionPlan(Plan plan) {
        this.preConditionPlanImpl(plan);

        String srcPath = Paths.get(genPath+ File.separator + "conditions", "PreCondition" + plan.getPreCondition().getId() + ".java").toString();
        String fileContentSource = plans.preConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void runtimeConditionPlanImpl(Plan plan) {
        String srcPath = Paths.get(implPath+ File.separator + "conditions", "RunTimeCondition" + plan.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.runtimeConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void runtimeConditionPlan(Plan plan) {
        this.runtimeConditionPlanImpl(plan);

        String srcPath = Paths.get(genPath+ File.separator + "conditions", "RunTimeCondition" + plan.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = plans.runtimeConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void transitionPreConditionPlanImpl(Transition transition) {
        String srcPath = Paths.get(implPath+ File.separator + "conditions", "PreCondition" + transition.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.transitionPreConditionPlanImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void transitionPreConditionPlan(State state, Transition transition) {
        this.transitionPreConditionPlanImpl(transition);
        String srcPath = Paths.get(genPath+ File.separator + "conditions", "PreCondition" + transition.getPreCondition().getId() + ".java").toString();
        String fileContentSource = transitions.transitionPreConditionPlan(state, transition);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createPlan(Plan plan) {
//        this.createPlanImpl(plan);
        this.utilityFunctionPlan(plan);
        if (plan.getPreCondition() != null) {
            this.preConditionPlan(plan);
        }
        if (plan.getRuntimeCondition() != null) {
            this.runtimeConditionPlan(plan);
        }
        List<State> states = plan.getStates();
        for (State state: states) {
            List<Transition> transitions = state.getOutTransitions();

            for (Transition transition: transitions) {

                if (transition.getPreCondition() != null) {
                    this.transitionPreConditionPlan(state, transition);
                }
            }
        }

//        String destinationPath = cutDestinationPathToDirectory(plan);
//        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + ".java";
//        String srcPath = Paths.get(genPath, destinationPath, filename).toString();
//        String fileContentSource = plans.plan(plan);
//        writeSourceFile(srcPath, fileContentSource);
//        formatFile(srcPath);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String srcPath = Paths.get(genPath+ File.separator + "creators", "UtilityFunctionCreator.java").toString();
        String fileContentSource = creators.utilityFunctionCreator(plans);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private String readFile(String path) {
        StringBuilder stringBuilder = new StringBuilder();
        try (Stream stream = Files.lines(Paths.get(path), StandardCharsets.UTF_8)) {
            stream.forEach(s -> stringBuilder.append(s).append("\n"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stringBuilder.toString();
    }

    private void writeFile(String path, String content) {
        try (
                Writer writer = new BufferedWriter(new OutputStreamWriter(
                        new FileOutputStream(path),
                        StandardCharsets.UTF_8
                ))
        ) {
            writer.write(content);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Calls the executable found by the formatter attribute on the file found by filename.
     * It is assumed that the executable is clang-format or has the same CLI as clang-format.
     *
     * @param fileName
     */
    @Override
    public void formatFile(String fileName) {
        String sourceString = readFile(fileName);
        try {
            String formattedSource = new Formatter().formatSource(sourceString);
            writeFile(fileName, formattedSource);
        } catch (FormatterException e) {
            LOG.error("An error occurred while formatting generated sources", e);
            e.printStackTrace();
        }
    }
}
