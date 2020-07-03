package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;

import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class GeneratedSourcesManagerCpp extends GeneratedSourcesManager {

    @Override
    public String getSourcePath() {
        return Paths.get(sourcePath, "src").toString();
    }

    public String getHeaderPath() {
        return Paths.get(sourcePath, "include").toString();
    }

    public List<File> getGeneratedFilesForBehaviour(Behaviour behaviour) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(behaviour.getRelativeDirectory());
        generatedFiles.add(Paths.get(getHeaderPath(), destinationPath, behaviour.getName() + ".h").toFile());
        generatedFiles.add(Paths.get(getSourcePath(), destinationPath, behaviour.getName() + ".cpp").toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConditionFilesForPlan(AbstractPlan abstractPlan) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(abstractPlan.getRelativeDirectory());
        String headerFilename = abstractPlan.getName() + abstractPlan.getId() + ".h";
        String sourceFilename = abstractPlan.getName() + abstractPlan.getId() + ".cpp";
        generatedFiles.add(Paths.get(getHeaderPath(), destinationPath, headerFilename).toFile());
        generatedFiles.add(Paths.get(getSourcePath(), destinationPath, sourceFilename).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConstraintFilesForPlan(AbstractPlan abstractPlan) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(abstractPlan.getRelativeDirectory());
        String constraintHeaderFileName = abstractPlan.getName() + abstractPlan.getId() + "Constraints.h";
        String constraintSourceFileName = abstractPlan.getName() + abstractPlan.getId() + "Constraints.cpp";
        generatedFiles.add(Paths.get(getHeaderPath(), destinationPath, "constraints", constraintHeaderFileName).toFile());
        generatedFiles.add(Paths.get(getSourcePath(), destinationPath, "constraints", constraintSourceFileName).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConstraintFilesForBehaviour(Behaviour behaviour) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(behaviour.getRelativeDirectory());
        String constraintHeaderFileName = behaviour.getName() + behaviour.getId() + "Constraints.h";
        String constraintSourceFileName = behaviour.getName() + behaviour.getId() + "Constraints.cpp";
        generatedFiles.add(Paths.get(getHeaderPath(), destinationPath, "constraints", constraintHeaderFileName).toFile());
        generatedFiles.add(Paths.get(getSourcePath(), destinationPath, "constraints", constraintSourceFileName).toFile());
        return generatedFiles;
    }
}
