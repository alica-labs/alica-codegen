package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IConstraintCodeGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;

import java.io.IOException;
import java.net.URL;

public class GeneratorImplPython extends GeneratorImpl {

//    @Override
    public void formatFile(String fileName) {
        if (this.formatter != null && this.formatter.length() > 0) {
            URL clangFormatStyle = GeneratorImplPython.class.getResource(".style.yapf");
            String command = this.formatter +
                    " --style=" + clangFormatStyle +
                    " " + fileName;
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

    @Override
    public void createConstraintsForPlan(Plan plan) {

    }

    @Override
    public void createPlan(Plan plan) {

    }

    @Override
    public IConstraintCodeGenerator getActiveConstraintCodeGenerator() {
        return null;
    }
}
