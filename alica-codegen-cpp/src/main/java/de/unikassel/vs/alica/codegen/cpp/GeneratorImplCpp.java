package de.unikassel.vs.alica.codegen.cpp;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManager;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerCpp;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * the following line have to be "import de.unikassel.vs.alica.codegen.cpp.XtendTemplates;"
 * otherwise it must be inserted again!
 */
import de.unikassel.vs.alica.codegen.cpp.XtendTemplates;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

/**
 * Code generator for C++. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManager}.
 */
public class GeneratorImplCpp extends GeneratorImpl implements IGenerator<GeneratedSourcesManagerCpp> {
    private XtendTemplates xtendTemplates;
    private GeneratedSourcesManagerCpp generatedSourcesManager;

    public GeneratorImplCpp() {
        xtendTemplates = new XtendTemplates();
    }

    @Override
    public void setGeneratedSourcesManager(GeneratedSourcesManagerCpp generatedSourcesManager) {
        this.generatedSourcesManager = generatedSourcesManager;
    }

    /**
     * delegate XtendTemplates#setProtectedRegions(Map)
     *
     * @param protectedRegions mapping from identifier to content of protected region
     */
    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {
        xtendTemplates.setProtectedRegions(protectedRegions);
    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "BehaviourCreator.h").toString();
        String fileContentHeader = xtendTemplates.behaviourCreatorHeader();
        writeSourceFile(headerPath, fileContentHeader);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "BehaviourCreator.cpp").toString();
        String fileContentSource = xtendTemplates.behaviourCreatorSource(behaviours);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createBehaviours(Behaviour behaviour) {
        String destinationPath = cutDestinationPathToDirectory(behaviour);

        //DomainBehaviour
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), destinationPath, behaviour.getName() + behaviour.getId() + ".h").toString();
        String fileContentHeader = xtendTemplates.behaviourConditionHeader(behaviour);
        writeSourceFile(headerPath, fileContentHeader);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, behaviour.getName() + behaviour.getId() + ".cpp").toString();
        String fileContentSource = xtendTemplates.behaviourConditionSource(behaviour);
        writeSourceFile(srcPath, fileContentSource);

        //Behaviour
        String headerPath2 = Paths.get(generatedSourcesManager.getIncludeDir(), destinationPath, behaviour.getName()+ ".h").toString();
        String fileContentHeader2 = xtendTemplates.behaviourHeader(behaviour);
        writeSourceFile(headerPath2, fileContentHeader2);

        String srcPath2 = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, behaviour.getName()+ ".cpp").toString();
        String fileContentSource2 = xtendTemplates.behaviourSource(behaviour);
        writeSourceFile(srcPath2, fileContentSource2);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "ConditionCreator.h").toString();
        String fileContentHeader = xtendTemplates.conditionCreatorHeader();
        writeSourceFile(headerPath, fileContentHeader);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "ConditionCreator.cpp").toString();
        String fileContentSource = xtendTemplates.conditionCreatorSource(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "ConstraintCreator.h").toString();
        String fileContentHeader = xtendTemplates.constraintCreatorHeader();
        writeSourceFile(headerPath, fileContentHeader);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "ConstraintCreator.cpp").toString();
        String fileContentSource = xtendTemplates.constraintCreatorSource(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createConstraintsForPlan(Plan plan) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(plan);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }
        String headerPath = Paths.get(constraintHeaderPath, plan.getName() + plan.getId() + "Constraints.h").toString();
        String fileContentHeader = xtendTemplates.constraintsHeader(plan);
        writeSourceFile(headerPath, fileContentHeader);

        String constraintSourcePath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, plan.getName() + plan.getId() + "Constraints.cpp").toString();
        String fileContentSource = xtendTemplates.constraintsSource(plan);
        writeSourceFile(srcPath, fileContentSource);

        for (State inPlan : plan.getStates()) {
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

    @Override
    public void createConstraintsForBehaviour(Behaviour behaviour) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(behaviour);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }
        String headerPath = Paths.get(constraintHeaderPath, behaviour.getName() + behaviour.getId() + "Constraints.h").toString();
        String fileContentHeader = xtendTemplates.constraintsHeader(behaviour);
        writeSourceFile(headerPath, fileContentHeader);

        String constraintSourcePath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, behaviour.getName() + behaviour.getId() + "Constraints.cpp").toString();
        String fileContentSource = xtendTemplates.constraintsSource(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createPlan(Plan plan) {
        String destinationPath = cutDestinationPathToDirectory(plan);

        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), destinationPath, plan.getName() + plan.getId() + ".h").toString();
        String fileContentHeader = xtendTemplates.planHeader(plan);
        writeSourceFile(headerPath, fileContentHeader);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, plan.getName() + plan.getId() + ".cpp").toString();
        String fileContentSource = xtendTemplates.planSource(plan);
        writeSourceFile(srcPath, fileContentSource);

        RuntimeCondition runtimeCondition = plan.getRuntimeCondition();
        if (runtimeCondition != null) {
            try {
                LineNumberReader lineNumberReader = new LineNumberReader(new FileReader(srcPath));
                while (lineNumberReader.ready()) {
                    if (lineNumberReader.readLine().contains("/*PROTECTED REGION ID(" + runtimeCondition.getId() + ") ENABLED START*/")) {
                        generatedSourcesManager.putLineForModelElement(runtimeCondition.getId(), lineNumberReader.getLineNumber());
                        break;
                    }

                }
                lineNumberReader.close();
            } catch (IOException e) {
                LOG.error("Could not open/read lines for " + srcPath, e);
            }
        }

        PreCondition preCondition = plan.getPreCondition();
        if (preCondition != null) {
            try {
                LineNumberReader lineNumberReader = new LineNumberReader(new FileReader(srcPath));
                while (lineNumberReader.ready()) {
                    if (lineNumberReader.readLine().contains("/*PROTECTED REGION ID(" + preCondition.getId() + ") ENABLED START*/")) {
                        generatedSourcesManager.putLineForModelElement(preCondition.getId(), lineNumberReader.getLineNumber());
                        break;
                    }

                }
                lineNumberReader.close();
            } catch (IOException e) {
                LOG.error("Could not open/read lines for " + srcPath, e);
            }
        }

        for (Transition inPlan : plan.getTransitions()) {
            try {
                LineNumberReader lineNumberReader = new LineNumberReader(new FileReader(srcPath));
                while (lineNumberReader.ready()) {
                    if (lineNumberReader.readLine().contains("/*PROTECTED REGION ID(" + inPlan.getId() + ") ENABLED START*/")) {
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

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "UtilityFunctionCreator.h").toString();
        String fileContentHeader = xtendTemplates.utilityFunctionCreatorHeader();
        writeSourceFile(headerPath, fileContentHeader);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "UtilityFunctionCreator.cpp").toString();
        String fileContentSource = xtendTemplates.utilityFunctionCreatorSource(plans);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createDomainCondition() {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "DomainCondition.h").toString();
        String fileContentHeader = xtendTemplates.domainConditionHeader();
        writeSourceFile(headerPath, fileContentHeader);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "DomainCondition.cpp").toString();
        String fileContentSource = xtendTemplates.domainConditionSource();
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createDomainBehaviour() {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "DomainBehaviour.h").toString();
        String fileContentHeader = xtendTemplates.domainBehaviourHeader();
        writeSourceFile(headerPath, fileContentHeader);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "DomainBehaviour.cpp").toString();
        String fileContentSource = xtendTemplates.domainBehaviourSource();
        writeSourceFile(srcPath, fileContentSource);
    }
}
