package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * IF the following line is not import de.unikassel.vs.alica.codegen.java.XtendTemplates;
 * you messed it up ... great ... you made the plandesigner great again ... huge ...
 * INSERT IT
 */
import de.unikassel.vs.alica.codegen.java.XtendTemplates;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.nio.file.Paths;
import java.util.List;


/**
 * Code generator for C++. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerJava}.
 * Every file that is written is formatted by the formatter that is set by setFormatter.
 */
public class GeneratorImplJava extends GeneratorImpl {
    private XtendTemplates xtendTemplates;
    private GeneratedSourcesManagerJava generatedSourcesManager;

    public GeneratorImplJava() {
        xtendTemplates = new XtendTemplates();
    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "BehaviourCreator.java").toString();
        String fileContentSource = xtendTemplates.behaviourCreator(behaviours);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createBehaviour(Behaviour behaviour) {
        String destinationPath = cutDestinationPathToDirectory(behaviour);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, behaviour.getName() + behaviour.getId() + ".java").toString();
        String fileContentSource = xtendTemplates.behaviourCondition(behaviour, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);

        String srcPath2 = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, behaviour.getName()+ ".java").toString();
        String fileContentSource2 = xtendTemplates.behaviour(behaviour);
        writeSourceFile(srcPath2, fileContentSource2);
        formatFile(srcPath2);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "ConditionCreator.java").toString();
        String fileContentSource = xtendTemplates.conditionCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "ConstraintCreator.java").toString();
        String fileContentSource = xtendTemplates.constraintCreator(plans, behaviours, conditions);
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

        String constraintSourcePath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, plan.getName() + plan.getId() + "Constraints.java").toString();
        String fileContentSource = xtendTemplates.constraints(plan, getActiveConstraintCodeGenerator());
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

    @Override
    public void createConstraintsForBehaviour(Behaviour behaviour) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(behaviour);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }

        String constraintSourcePath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, behaviour.getName() + behaviour.getId() + "Constraints.java").toString();
        String fileContentSource = xtendTemplates.constraints(behaviour, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createPlan(Plan plan) {
        String destinationPath = cutDestinationPathToDirectory(plan);

        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), destinationPath, plan.getName() + plan.getId() + ".java").toString();
        String fileContentSource = xtendTemplates.plan(plan, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "UtilityFunctionCreator.java").toString();
        String fileContentSource = xtendTemplates.utilityFunctionCreator(plans);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createDomainCondition() {
        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "DomainCondition.java").toString();
        String fileContentSource = xtendTemplates.domainCondition();
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createDomainBehaviour() {
        String srcPath = Paths.get(generatedSourcesManager.getSrcDir(), "DomainBehaviour.java").toString();
        String fileContentSource = xtendTemplates.domainBehaviour();
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
//        if (formatter != null && formatter.length() > 0) {
//            URL clangFormatStyle = GeneratorImplJava.class.getResource(".clang-format");
//            String command = formatter +
//                    " -style=" + clangFormatStyle +
//                    " -i " + fileName;
//            try {
//                Runtime.getRuntime().exec(command).waitFor();
//            } catch (IOException | InterruptedException e) {
//                LOG.error("An error occurred while formatting generated sources", e);
//                throw new RuntimeException(e);
//            }
//        } else {
//            LOG.warn("Generated files are not formatted because no formatter is configured");
//        }
    }
}
