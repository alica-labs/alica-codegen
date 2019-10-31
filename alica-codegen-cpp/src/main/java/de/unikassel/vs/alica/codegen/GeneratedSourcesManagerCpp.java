package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;

import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class GeneratedSourcesManagerCpp extends GeneratedSourcesManager {

    public String getIncludeDir() {
        return Paths.get(genSrcPath, "include").toString();
    }

    public String getSrcDir() {
        return Paths.get(genSrcPath, "src").toString();
    }

    public List<File> getGeneratedFilesForBehaviour(Behaviour behaviour) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(behaviour.getRelativeDirectory());
        generatedFiles.add(Paths.get(getIncludeDir(), destinationPath, behaviour.getName() + ".h").toFile());
        generatedFiles.add(Paths.get(getSrcDir(), destinationPath, behaviour.getName() + ".cpp").toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConditionFilesForPlan(AbstractPlan abstractPlan) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(abstractPlan.getRelativeDirectory());
        String headerFilename = abstractPlan.getName() + abstractPlan.getId() + ".h";
        String sourceFilename = abstractPlan.getName() + abstractPlan.getId() + ".cpp";
        generatedFiles.add(Paths.get(getIncludeDir(), destinationPath, headerFilename).toFile());
        generatedFiles.add(Paths.get(getSrcDir(), destinationPath, sourceFilename).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConstraintFilesForPlan(AbstractPlan abstractPlan) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(abstractPlan.getRelativeDirectory());
        String constraintHeaderFileName = abstractPlan.getName() + abstractPlan.getId() + "Constraints.h";
        String constraintSourceFileName = abstractPlan.getName() + abstractPlan.getId() + "Constraints.cpp";
        generatedFiles.add(Paths.get(getIncludeDir(), destinationPath, "constraints", constraintHeaderFileName).toFile());
        generatedFiles.add(Paths.get(getSrcDir(), destinationPath, "constraints", constraintSourceFileName).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConstraintFilesForBehaviour(Behaviour behaviour) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(behaviour.getRelativeDirectory());
        String constraintHeaderFileName = behaviour.getName() + behaviour.getId() + "Constraints.h";
        String constraintSourceFileName = behaviour.getName() + behaviour.getId() + "Constraints.cpp";
        generatedFiles.add(Paths.get(getIncludeDir(), destinationPath, "constraints", constraintHeaderFileName).toFile());
        generatedFiles.add(Paths.get(getSrcDir(), destinationPath, "constraints", constraintSourceFileName).toFile());
        return generatedFiles;
    }
}
