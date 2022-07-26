import React, { useEffect, useState } from "react";
import moment from "moment";
import AddCircleIcon from "@mui/icons-material/AddCircle";
import ReactDOM from "react-dom";
import { Link } from "react-router-dom";
const eventColors = [
	"#cfe2f3",
	"#f4cccc",
	"#fff2cc",
	"#d9ead3",
	"#d9d2e9",
	"#8cdf86",
	"#f4d0ae",
];
const TileContent = ({ uId, date, view, uType }) => {
	const [eventList, setEventList] = useState([]);
	//   const [eventList, setEventList] = useState(events);

	const dateMoment = moment(date);
	const dateOnly = dateMoment.date();
	const monthOnly = dateMoment.month();
	const yearOnly = dateMoment.year();
	//   console.log("date " + dateOnly, "month " + monthOnly, "year " + yearOnly);

	useEffect(() => {
		const fetchData = async (calendarPostBody) => {
			// calendarPostBody -> uId, date, month, year
			try {
				const res = await fetch(`/api/calendar/month`, {
					method: "POST",
					headers: {
						"Content-type": "application/json",
					},
					body: JSON.stringify(calendarPostBody),
				});
				const jsonData = await res.json();
				// console.log(jsonData);
				// console.log(res.status);
				if (res.status === 200) {
					setEventList(jsonData.eventList);
				} else {
					//   alert(jsonData.message);
					//   console.log(jsonData.message);
				}
			} catch (err) {
				console.log(err);
				// alert(err);
			}
		};
		fetchData({ uId, date: dateOnly, month: monthOnly, year: yearOnly, uType });
	}, []);

	// list of hours
	const hours = [];
	for (let i = 0; i < 24; i++) {
		// hh:mm format
		hours.push(moment(`${i}:00`, "h:mm a").format("h:mm a"));
	}
	// console.log(hours);
	// return tileElement;
	return (
		<>
			{view === "month" ? (
				<div className="calendar__monthly__inside__content">
					{hours.map((hour, index) => {
						return (
							<div
								key={index}
								className="calendar__monthly__inside__content__line"
							>
								{/* <div style={{ background: "#000" }}>event details</div> */}
								<div className="calendar__monthly__event__list">
									{eventList.map((event, index) => {
										return (
											<div
												key={index}
												className="calendar__monthly__event__particular"
											>
												{moment(event.lookup_time, "hh:mm:ss").isBetween(
													moment(hour, "h:mm a").subtract(1, "minutes"),
													moment(hour, "h:mm a").add(1, "hour")
												) ? (
													<>
														<div
															className="calendar__monthly__event"
															style={{
																background:
																	eventColors[event.event_type_id - 1],
															}}
														>
															{event.event_type_id === 1 ? (
																<>
																	{event.dept_shortname} {event.course_code}{" "}
																	{event.event_type}
																</>
															) : (
																<>
																	<Link
																		to={`/course/${event.id}/event/${event.eventid}`}
																	>
																		{event.dept_shortname} {event.course_code}{" "}
																		{event.event_type}
																	</Link>
																</>
															)}
														</div>
														<div className="calendar__monthly__hourstamp">
															{moment(event.lookup_time, "hh:mm:ss").format(
																"h:mm a"
															)}
														</div>
													</>
												) : (
													<></>
												)}
											</div>
										);
									})}
								</div>
							</div>
						);
					})}
				</div>
			) : (
				<></>
			)}
		</>
	);
};

export default TileContent;
