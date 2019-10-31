package de.unikassel.vs.alica.codegen.cpp;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManager;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * IF the following line is not import de.unikassel.vs.alica.codegen.cpp.XtendTemplates;
 * you messed it up ... great ... you made the plandesigner great again ... huge ...
 * INSERT IT
 */
import de.unikassel.vs.alica.codegen.cpp.XtendTemplates;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.net.URL;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

/**
 * Code generator for C++. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManager}.
 * Every file that is written is formatted by the formatter that is set by setFormatter.
 */
public class GeneratorImplCpp extends GeneratorImpl {
    private XtendTemplates xtendTemplates;

    public GeneratorImplCpp() {
        xtendTemplates = new XtendTemplates();
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

        formatFile(headerPath);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "BehaviourCreator.cpp").toString();
        String fileContentSource = xtendTemplates.behaviourCreatorSource(behaviours);
        writeSourceFile(srcPath, fileContentSource);

        formatFile(srcPath);
    }

    @Override
    public void createBehaviour(Behaviour behaviour) {
        String destinationPath = cutDestinationPathToDirectory(behaviour);

        //DomainBehaviour
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), destinationPath, behaviour.getName() + behaviour.getId() + ".h").toString();
        String fileContentHeader = xtendTemplates.behaviourConditionHeader(behaviour);
        writeSourceFile(headerPath, fileContentHeader);

        formatFile(headerPath);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, behaviour.getName() + behaviour.getId() + ".cpp").toString();
        String fileContentSource = xtendTemplates.behaviourConditionSource(behaviour, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);

        formatFile(srcPath);

        //Behaviour
        String headerPath2 = Paths.get(generatedSourcesManager.getIncludeDir(), destinationPath, behaviour.getName()+ ".h").toString();
        String fileContentHeader2 = xtendTemplates.behaviourHeader(behaviour);
        writeSourceFile(headerPath2, fileContentHeader2);

        formatFile(headerPath2);

        String srcPath2 = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, behaviour.getName()+ ".cpp").toString();
        String fileContentSource2 = xtendTemplates.behaviourSource(behaviour);
        writeSourceFile(srcPath2, fileContentSource2);

        formatFile(srcPath2);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "ConditionCreator.h").toString();
        String fileContentHeader = xtendTemplates.conditionCreatorHeader();
        writeSourceFile(headerPath, fileContentHeader);

        formatFile(headerPath);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "ConditionCreator.cpp").toString();
        String fileContentSource = xtendTemplates.conditionCreatorSource(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);

        formatFile(srcPath);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "ConstraintCreator.h").toString();
        String fileContentHeader = xtendTemplates.constraintCreatorHeader();
        writeSourceFile(headerPath, fileContentHeader);

        formatFile(headerPath);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "ConstraintCreator.cpp").toString();
        String fileContentSource = xtendTemplates.constraintCreatorSource(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);

        formatFile(srcPath);
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

        formatFile(headerPath);

        String constraintSourcePath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, plan.getName() + plan.getId() + "Constraints.cpp").toString();
        String fileContentSource = xtendTemplates.constraintsSource(plan, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);

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

        formatFile(headerPath);

        String constraintSourcePath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, behaviour.getName() + behaviour.getId() + "Constraints.cpp").toString();
        String fileContentSource = xtendTemplates.constraintsSource(behaviour, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createPlan(Plan plan) {
        String destinationPath = cutDestinationPathToDirectory(plan);

        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), destinationPath, plan.getName() + plan.getId() + ".h").toString();
        String fileContentHeader = xtendTemplates.planHeader(plan);
        writeSourceFile(headerPath, fileContentHeader);

        formatFile(headerPath);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, plan.getName() + plan.getId() + ".cpp").toString();
        String fileContentSource = xtendTemplates.planSource(plan, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);

        formatFile(srcPath);

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

        formatFile(headerPath);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "UtilityFunctionCreator.cpp").toString();
        String fileContentSource = xtendTemplates.utilityFunctionCreatorSource(plans);
        writeSourceFile(srcPath, fileContentSource);

        formatFile(srcPath);
    }

    @Override
    public void createDomainCondition() {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "DomainCondition.h").toString();
        String fileContentHeader = xtendTemplates.domainConditionHeader();
        writeSourceFile(headerPath, fileContentHeader);

        formatFile(headerPath);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "DomainCondition.cpp").toString();
        String fileContentSource = xtendTemplates.domainConditionSource();
        writeSourceFile(srcPath, fileContentSource);

        formatFile(srcPath);
    }

    @Override
    public void createDomainBehaviour() {
        String headerPath = Paths.get(generatedSourcesManager.getIncludeDir(), "DomainBehaviour.h").toString();
        String fileContentHeader = xtendTemplates.domainBehaviourHeader();
        writeSourceFile(headerPath, fileContentHeader);

        formatFile(headerPath);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "DomainBehaviour.cpp").toString();
        String fileContentSource = xtendTemplates.domainBehaviourSource();
        writeSourceFile(srcPath, fileContentSource);

        formatFile(srcPath);
    }

    /**
     * Calls the executable found by the formatter attribute on the file found by filename.
     * It is assumed that the executable is clang-format or has the same CLI as clang-format.
     *
     * @param fileName
     */
    @Override
    public void formatFile(String fileName) {
        if (formatter != null && formatter.length() > 0) {
            URL clangFormatStyle = GeneratorImplCpp.class.getResource(".clang-format");
            String command = formatter +
                    " -style=" + clangFormatStyle +
                    " -i " + fileName;
            try {
                Runtime.getRuntime().exec(command).waitFor();
            } catch (IOException | InterruptedException e) {
                LOG.error("An error occurred while formatting generated sources", e);
                throw new RuntimeException(e);
            }
        } else {
            LOG.warn("Generated files are not formatted because no formatter is configured");
        }
    }
}
