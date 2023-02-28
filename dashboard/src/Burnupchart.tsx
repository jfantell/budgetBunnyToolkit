import React, { useRef, useEffect } from "react";
import * as d3 from "d3";
import "./Burnupchart.css"

// This value will eventually be stored
// and queried from a database as it is different
// for each user and category
const BUDGETED_AMOUNT = 600;

interface IData {
    date: string;
    cumulative_amount: number;
}

interface IProps {
    data: IData[];
}

export const BurnupChart: React.FC<IProps> = ({ data }) => {
    const chartRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (!chartRef.current || data.length < 1) {
            return;
        }

        const margin = { top: 20, right: 20, bottom: 30, left: 50 };
        const width = 960 - margin.left - margin.right;
        const height = 500 - margin.top - margin.bottom;

        const svg = d3
            .select(chartRef.current)
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", `translate(${margin.left},${margin.top})`);

        const xScale = d3
            .scaleTime()
            .domain(d3.extent(data, (d) => new Date(d.date)) as [Date, Date])
            .range([0, width]);

        const maxAmount = d3.max(data, (d) => d3.max([d.cumulative_amount, BUDGETED_AMOUNT]));
        if (!maxAmount) {
            console.error('Unable to compute y axis max expense')
            return;
        }
        const yScale = d3.scaleLinear().range([height, 0]).domain([0, maxAmount]);

        const actualLine = d3
            .line<IData>()
            .x((d) => xScale(new Date(d.date)))
            .y((d) => yScale(d.cumulative_amount));

        const budgetLine = d3
            .line<IData>()
            .x((d) => xScale(new Date(d.date)))
            .y((d) => yScale(BUDGETED_AMOUNT));

        svg
            .append("path")
            .datum(data)
            .attr("class", "actual-line")
            .attr("d", actualLine);

        svg
            .append("path")
            .datum(data)
            .attr("class", "budget-line")
            .attr("d", budgetLine);

        svg
            .append("rect")
            .attr("class", "budget-area")
            .attr("x", 0)
            .attr("y", 0)
            .attr("width", width)
            .attr("height", yScale(d3.max(data, (d) => BUDGETED_AMOUNT) as number));

        svg
            .append("rect")
            .attr("class", "actual-area")
            .attr("x", 0)
            .attr("y", 0)
            .attr("width", 0)
            .attr("height", height);

        svg
            .selectAll(".dot")
            .data(data)
            .enter()
            .append("circle")
            .attr("class", "dot")
            .attr("cx", (d) => xScale(new Date(d.date)))
            .attr("cy", (d) => yScale(d.cumulative_amount))
            .attr("r", 5);

        svg
            .append("g")
            .attr("transform", `translate(0,${height})`)
            .call(d3.axisBottom(xScale));

        svg.append("g").call(d3.axisLeft(yScale));


        const actualArea = d3
            .area<IData>()
            .x((d) => xScale(new Date(d.date)))
            .y0(height)
            .y1((d) => yScale(BUDGETED_AMOUNT));

        svg
            .append("path")
            .datum(data)
            .attr("class", "actual-area")
            .attr("d", actualArea);

        // Add the title
        svg
            .append("text")
            .attr("x", width / 2)
            .attr("y", 0 - margin.top / 2)
            .attr("text-anchor", "middle")
            .style("font-size", "14px")
            .text("Budgeted Expenses vs Actual Expenses: Food and Drink");

        return () => {
            svg.remove();
        };
    }, [data]);

    return <div ref={chartRef}></div>;
};

export default BurnupChart;